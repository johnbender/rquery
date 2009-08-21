module RQuery
  class OperationCollector
    
    def initialize
      # @name, @prefix = optns[:name], optns[:prefix]
      @operations = []
      @values = []
    end

    def to_s
      RQuery::Config.adapter.join(@operations)
    end
    
    #return a conditions array for use with ActiveRecord.find
    def conditions
      [to_s] + @values
    end
    
    #add and operation to the @operations array which will be popped
    #and pushed depending on the operations sequence and arrangement
    def add_operation(val)
      @operations << val.to_s
      self
    end
    
    #grouping is done by using the | and & operators between multiple operations
    #objects on a single line.
    #
    #This works because each operation ie (user.age.is == 2) is
    #evaluated before these two operators thus pushing
    #the equivelant operation string onto the @operations array (ie 'age = ?'). 
    #When an operation is evaluated it returns the Operations class which can be compared
    #using the aforementioned operators. Those operators call the group method
    #popping the last two arguments off the stack and dealing with them in one of two ways
    #
    #1. if the second object popped is a string both objects should be
    #   added to a new OperationGroup which is then put back onto the stack
    #
    #2. if the second object popped is an OperationGroup the firest belongs to this group as
    #   well (it was on the same line). It is added to the OperationGroup and put back on the
    #   stack
    def group(type)
      second_op, first_op = @operations.pop, @operations.pop
      
      #if the previous operation on the stack is an Operation Group we need to add to it
      if first_op.class == OperationsGroup
        if first_op.type == type
          first_op.ops << second_op
          @operations << first_op
        else
          @operations << OperationsGroup.new(first_op.to_s, second_op, type)
        end
      else
        @operations << OperationsGroup.new(first_op, second_op, type)
      end

      self
    end
    
    #used to group operations for anding on a single line
    #example with sqlite adapter
    #(user.age.in [1,2,3]) | (user.name.contains "foo")
    #=>(age in (?) and name like '%' || 'foo' || '%')
    def &(second)
      group :and
    end
    
    def |(second)
      group :or
    end

    def in(*args)
      #flatten our args to prevent having to check for an array first arg
      args.flatten!
      
      #if a range is passed as the first argument 
      #use it alone, otherwise use the args array 
      #examples:
      #ruby => args.flatten! => stored values
      #:id.between 1..100 => [1..100] => 1..100
      #:id.between [1, 2, 3] => [1, 2, 3] => [1, 2, 3]
      #:id.between 1, 2 => [1, 2] => [1, 2] 
      @values << (args.first.class == Range ? args.first : args)
      chain :in
    end
    
    def between(*args)
      #flatten our args to prevent having to check for an array first arg
      args.flatten!
      
      #if a range is passed use its first/last element 
      #otherwise use the first and last element of the flattened args array
      #examples:
      #ruby => args.flatten! => stored values
      #:id.between 1..100 => [1..100] => 1 100
      #:id.between [1, 2, 3] => [1, 2, 3] => 1 3
      #:id.between 1, 2 => [1, 2] => 1 2 
 
      @values += (args.first.class == Range ? [args.first.first, args.first.last] : [args.first, args.last])
      chain :between
    end
    
    def contains(str)
      @values << str
      chain :contains
    end

    def not=(arg)
      @values << arg
      chain :neq
    end

    [:==, :>, :>=, :<, :<=, :neq].each do |operator|                    
      define_method(operator) do |val|
        @values << val
        chain operator
      end
    end
    
    #allows for is.from
    #examples:
    #
    #:id.is.from 1,2
    #:is.is.from 2..10
    alias :from :between

    private 
    def chain(method)
      @operations[@operations.length-1] += " #{RQuery::Config.adapter.send(method)}"
      self
    end
  end

  
  class OperationsGroup
    attr_accessor :ops, :type
    
    def initialize(left, right, type)
      @ops = Array.new
      @ops << left
      @ops << right
      @type = type
    end
    
    def to_s
      RQuery::Config.adapter.send("#{type.to_s}_group", @ops)
    end
  end
end

module RQuery
  class OperationCollector
    NOT_PREFIX = 'not_'
    NIL_PREFIX = ''

    def initialize
      # @name, @prefix = optns[:name], optns[:prefix]
      @operations = []
      @values = []
    end

    def to_s
      RQuery::Config.adapter.join(@operations)
    end
    
    #return a conditions array for use with ActiveRecord.find
    def to_conditions
      [to_s] + @values
    end
    
    #add and operation to the @operations array which will be popped
    #and pushed depending on the operations sequence and arrangement
    def add_operation(val)
      @operations << val.to_s
      self
    end
    
    #used to group operations for anding on a single line
    #example with sqlite adapter
    #(user.age.in [1,2,3]) | (user.name.contains "foo")
    #=>(age in (?) and name like '%' || 'foo' || '%')
    #
    # note that second is not used in this case because it should
    # have been collected into the @operations array earlier
    def &(second)
      @operations << AndOperationsGroup.new(tail_ops!(2))
      self
    end
    
    def |(second)
      @operations << OrOperationsGroup.new(tail_ops!(2))
      self
    end

    def in(*args)
      call_in(NIL_PREFIX, *args)
    end
    
    def not_in(*args)
      call_in(NOT_PREFIX, *args)
    end
    
    def between(*args)
      call_between(NIL_PREFIX, *args)
    end
    
    def not_between(*args)
      call_between(NOT_PREFIX, *args)
    end

    def contains(str)
      @values << str
      chain :contains
    end

    def without(str)
      @values << str
      chain :without
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
    alias :not_from :not_between

    private
    def tail_ops!(num)
      @operations.slice!(@operations.length-2, num)
    end
    
    def chain(method)
      @operations[@operations.length-1] += " #{RQuery::Config.adapter.send(method)}"
      self
    end

    def call_in(prefix, *args)
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
      chain :"#{prefix}in"
    end

    def call_between(prefix, *args)      
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
      chain :"#{prefix}between"
    end
  end
end

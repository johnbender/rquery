module RQuery
  module Serializers
    #The Operations serializer, handles the limiting factors imposed
    #by a given query. The methods in this class apply to both is and is_not
    #operations. An example in sql would look like:
    #
    #where foo = bar and foo > 2
    #
    #This class is a gateway to the selected RQuery.adapter methods.
    #Calls to methods here, will be passed on to the selected adapter 
    class Operations
      
      @@prefix = nil
      @@ops = []
      @@values = []
      
      class << self
        def prefix=(val)
          @@prefix = val
        end
        
        def to_s
          puts @@ops
          RQuery.adapter.join(@@ops)
        end
        
        def conditions
          [to_s] + @@values
        end
        
        def add_operation(val)
          @@ops << val.to_s
        end
        
        def clear
          @@ops.clear
          @@values.clear
        end
        
        def group(type)
          second_op, first_op = @@ops.pop, @@ops.pop
          
          #if the previous operation on the stack is an Operation Group we need to add to it
          if first_op.class == RQuery::Serializers::OperationsGroup
            first_op.ops << second_op
            @@ops << first_op
          else
            @@ops << OperationsGroup.new(first_op, second_op, type)
          end
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
          #
          @@values << (args.first.class == Range ? args.first : args)
          @@ops[@@ops.length-1] += " #{RQuery.adapter.send("#{@@prefix}in")}"
          RQuery::LogicStub.new
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
          #
          @@values += (args.first.class == Range ? [args.first.first, args.first.last] : [args.first, args.last])
          @@ops[@@ops.length-1] += " #{RQuery.adapter.send("#{@@prefix}between")}"
          RQuery::LogicStub.new
        end
        
        def contains(str)
          @@values << str
          @@ops[@@ops.length-1] += " #{RQuery.adapter.send("#{@@prefix}contains")}"
          RQuery::LogicStub.new
        end
        
        #allows for is.from
        #examples:
        #
        #:id.is.from 1,2
        #:is.is.from 2..10
        alias :from :between
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
        RQuery.adapter.send("#{type.to_s}_group", @ops)
      end
    end
    
    #The IsOpertaions serializer defines only methods that apply to the .is operator
    #that is added to the Symbol class in the Declarations module.
    class IsOperations < Operations
      #define the normal operators for is to call the adapter for the equivelant sql
      class << self
        [:==, :>, :>=, :<, :<=].each do |operator|                    
          define_method(operator) do |val|
            @@values << val
            @@ops[@@ops.length-1] += " #{RQuery.adapter.send(operator)}"
            RQuery::LogicStub.new
          end
        end
      end

    end
    
    #The IsNotOperations serializer defines only methods that apply to the .is_not operator
    #that is added to the symbol class in the declarations module. Specifically, == as 
    #ruby does not allow for the overloading of !=
    class IsNotOperations < Operations      
      #define the == value for is_not to call the adapter for the equivelant sql
      class << self
        define_method(:==) do |val|
          @@values << val
          @@ops[@@ops.length-1] += " #{RQuery.adapter.send(:neq)}"
          RQuery::LogicStub.new
        end
      end

    end  

  end
end

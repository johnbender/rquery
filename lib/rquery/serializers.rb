module RQuery
    module Serializers
        class Operations
        
            @@prefix = nil
            @@ops = []
            @@values = []

            class << self
                def prefix=(val)
                    @@prefix = val
                end

                def to_s
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

                def in(*args)
                    #flatten our args to prevent having to check for an array first arg
                    args.flatten!
                    
                    #if a range (or anything else that responds to :first) is passed as the first argument 
                    #use it alone, otherwise use the args array 
                    #examples:
                    #ruby => args.flatten! => stored values
                    #:id.between 1..100 => [1..100] => 1..100
                    #:id.between [1, 2, 3] => [1, 2, 3] => [1, 2, 3]
                    #:id.between 1, 2 => [1, 2] => [1, 2] 
                    #
                    @@values << (args.first.respond_to?(:first) ? args.first : args)
                    @@ops[@@ops.length-1] += " #{RQuery.adapter.send("#{@@prefix}in")}"
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
                    @@values += args.first.respond_to?(:first) ? [args.first.first, args.first.last] : [args.first, args.last]
                    
                    #store the operation string
                    #example:
                    #:id.between 1..100 "id between ? and ?"
                    #
                    @@ops[@@ops.length-1] += " #{RQuery.adapter.send("#{@@prefix}between")}"
                end

                def contains(str)
                    @@values << str
                    @@ops[@@ops.length-1] += " #{RQuery.adapter.send("#{@@prefix}contains")}"
                end

                #allows for is.from
                #examples:
                #
                #:id.is.from 1,2
                #:is.is.from 2..10
                alias :from :between

            end

        end

        class IsOperations < Operations

            #define the normal operators for is to call the adapter for the equivelant sql
            class << self
                [:==, :>, :>=, :<, :<=].each do |operator|                    
                    define_method(operator) do |val|
                        @@values << val
                        @@ops[@@ops.length-1] += " #{RQuery.adapter.send(operator)}"
                    end
                end
            end
        end

        class IsNotOperations < Operations

            #define the == value for is_not to call the adapter for the equivelant sql
            class << self
                define_method(:==) do |val|
                    @@values << val
                    @@ops[@@ops.length-1] += " #{RQuery.adapter.send(:neq)}"
                end
            end

        end
    
    end
end

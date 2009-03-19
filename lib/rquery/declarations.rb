
module RQuery
    module Declarations
        def is
            ::RQuery::Serializers::IsOperations.add_operation(self)
            ::RQuery::Serializers::IsOperations.prefix = nil
            ::RQuery::Serializers::IsOperations
        end

        def is_not
            ::RQuery::Serializers::IsNotOperations.add_operation(self)
            ::RQuery::Serializers::IsNotOperations.prefix = "not_"
            ::RQuery::Serializers::IsNotOperations
        end

        def in(*args)
            ::RQuery::Serializers::IsOperations.add_operation(self)
            ::RQuery::Serializers::IsOperations.prefix = nil
            ::RQuery::Serializers::IsOperations.in(*args)
        end

        def between(*args)
            ::RQuery::Serializers::IsOperations.add_operation(self)
            ::RQuery::Serializers::IsOperations.prefix = nil
            ::RQuery::Serializers::IsOperations.between(*args)
        end

        def contains(val)
            ::RQuery::Serializers::IsOperations.add_operation(self)
            ::RQuery::Serializers::IsOperations.prefix = nil
            ::RQuery::Serializers::IsOperations.contains(val)
        end

        alias :from :between
    end
end

Symbol.send :include, RQuery::Declarations


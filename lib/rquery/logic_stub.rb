module RQuery
    class LogicStub

      def &(second)
        RQuery::Serializers::Operations.group(:and)
        LogicStub.new
      end

      def |(second)
        RQuery::Serializers::Operations.group(:or)
        LogicStub.new
      end
    end
end

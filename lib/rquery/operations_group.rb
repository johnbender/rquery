module RQuery
  class OperationsGroup
    attr_accessor :ops
    
    def initialize(args)
      @ops = Array.new
      #if the two arguments passed are strings, make a new group
      if args[0].instance_of? String
        @ops << args[0] << args[1]
      else #otherwise make the operation the sum of the passed in operation and an additional
        @ops += args[0].ops << args[1]
      end
    end
    
    def to_s
      RQuery::Config.adapter.send("#{@type.to_s}_group", @ops)
    end
  end

  class OrOperationsGroup < OperationsGroup 
    def initialize(args)
      super(args)
      @type = :or 
    end
  end

  class AndOperationsGroup < OperationsGroup 
    def initialize(args)
      super(args)
      @type = :and 
    end
  end
end

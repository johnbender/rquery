module RQuery
  class OperationsGroup
    attr_accessor :ops
    
    def initialize(args)
      @ops = Array.new
      #if the two args passed are strings make a new group
      #otherwise add the second arg to the previous operation group
      @ops = args[0].instance_of?(String) ? args[0,2] : (args[0].ops << args[1])
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

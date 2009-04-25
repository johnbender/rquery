module RQuery
  module Declarations
    #Allows the methods below to be included in 
    #the Field class and the Symbol class but remain
    #the same in implementation
    #!name is redefined as an attr_accessor in the Field class!
    def name
      self.to_s if @name == nil
    end
    
    def is
      Serializers::IsOperations.add_operation(name)
      Serializers::IsOperations.prefix = nil
      Serializers::IsOperations
    end
    
    def is_not
      Serializers::IsNotOperations.add_operation(name)
      Serializers::IsNotOperations.prefix = "not_"
      Serializers::IsNotOperations
    end
    
    [:in, :between, :contains].each do |m|
      define_method(m) do |*args|
        Serializers::IsOperations.add_operation(name)
        Serializers::IsOperations.prefix = nil
        Serializers::IsOperations.send(m, *args)
      end
    end
    
    alias :from :between
  end
end


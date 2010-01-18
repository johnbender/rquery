module RQuery
  class AttributeCollection
    attr_reader :clauses

    def initialize(fields)
      @clauses = OperationCollector.new

      # For each field define it and its setter to add the appropriate clause
      fields.each do |field|
        self.class.send(:define_method, field) do |*args|
          add_clause(field)
          @clauses
        end

        self.class.send(:define_method, (field + '=')) do |*args|
          add_clause(field)
          eq(*args)
          @clauses
        end
      end
    end

    private
    def add_clause(str)
      @clauses.add_operation(str)
    end
    
    def eq(*args)
      @clauses.send(:==, *args)
    end
  end
end

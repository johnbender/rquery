module RQuery
  class AttributeCollection
    attr_reader :clauses

    def initialize(fields)
      @fields = fields.map{ |x| x.to_s }
      @clauses = OperationCollector.new
    end

    #if the field was added upon initialization its a valid call
    #otherwise report to the user it is invalid. Reports errors at the ruby level
    #instead of the data store level with something like "column doesn't exist"
    #
    #example
    #
    # >> user = RQuery::FieldCollection.new([:age, :name])
    # => #<RQuery::FieldCollection:0x1a2c21c @fields=[:age, :name]>
    # >> user.age
    # => #<RQuery::Field:0x1a2b240 @name=:age>
    # >> user.name
    # => #<RQuery::Field:0x1a2a390 @name=:name>
    # >> user.weight
    # ArgumentError: The field 'weight' doesn't exist for this object
    # 	from /Users/johnbender/Projects/rquery/lib/rquery/where_clause.rb:20:in `method_missing'
    # 	from (irb):5
    def method_missing(symbol, *args)
      attr_str = symbol.to_s
      eq_str = attr_str.gsub(/=/, '')

      if @fields.include?(attr_str) #if the method is part of the attributes 
        add_clause(attr_str)
      elsif @fields.include?(eq_str) #if the method sans '=' is part of the attributes
        add_clause(eq_str)
        eq(*args)
      else
        raise AttributeNotFoundError, "The field '#{symbol.to_s}' doesn't exist for this object" 
      end

      #explicit return of OperationCollector, same instance returned by methods of Operation collector
      #but included here for clarity
      @clauses
    end


    private
    def add_clause(str)
      @clauses.add_operation(str)
    end
    
    def eq(*args)
      @clauses.send(:==, *args)
    end

  end

  class AttributeNotFoundError < ArgumentError; end
end

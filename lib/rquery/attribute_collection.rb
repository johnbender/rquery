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

      if @fields.include?(attr_str)
        @clauses.add_operation(attr_str)
      elsif @fields.include?(eq_str)
        @clauses.add_operation(eq_str)
        @clauses.send(:==, *args)
        @clauses
      else
        raise AttributeNotFoundError, "The field '#{symbol.to_s}' doesn't exist for this object" 
      end
    end

  end

  class AttributeNotFoundError < ArgumentError; end
end

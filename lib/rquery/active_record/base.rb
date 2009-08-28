module RQuery
  module ActiveRecord
    def where(*args, &block)
      collector = RQuery::AttributeCollection.new(self.new.attribute_names)
      
      #Passes a new AttributeCollection object to the block, which will in turn
      #instantiate a OperationCollector to be used for each expression
      yield(collector)

      #record altered conditions and values
      conditions = collector.clauses.to_conditions

      #limit the records returned (:first, :all, :last)
      limit = args.first ? args.first : :all

      #call find with the conditions and values provided by the block
      find(limit, :conditions => conditions)
    end
  end
end

#extend ActiveRecord::Base with the where method 
if Object.const_defined?(:ActiveRecord)
  ActiveRecord::Base.send :extend, RQuery::ActiveRecord
end

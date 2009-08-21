module RQuery
  module ActiveRecord
    def where(*args, &block)
      collector = RQuery::AttributeCollection.new(self.new.attribute_names)
      
      #Passes a new AttributeCollection object to the block
      #if RQuery.use_symbols has been called it may not be used
      #but otherwise will take the form attr_coll_object.attribute.is ...
      yield(collection)

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

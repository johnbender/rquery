module RQuery
  module ActiveRecord
    @@where_mutex = Mutex.new
    def where(*args, &block)

      #establish scope for conditions
      conditions = nil

      #make sure only one thread at a time is altering the class
      #variables inside RQuery::Serializers::Operations
      @@where_mutex.synchronize do

        #Passes a new AttributeCollection object to the block
        #if RQuery.use_symbols has been called it may not be used
        #but otherwise will take the form attr_coll_object.attribute.is ...
        yield(RQuery::AttributeCollection.new(self.new.attribute_names))

        #record altered conditions and values
        conditions = ::RQuery::Serializers::Operations.conditions

        #clear the alterations
        RQuery::Serializers::Operations.clear
      end

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

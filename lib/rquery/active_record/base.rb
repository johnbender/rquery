module RQuery
  module ActiveRecord
    module ClassMethods
      def where(*args, &block)
        collector = AttributeCollection.new(self.new.attribute_names)
        
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

      def sniper_scope(name, &block)
        #rescope self
        klass = self
        named_scope name, lambda { |*args|
          collector = AttributeCollection.new(klass.new.attribute_names)
          block.call(collector, *args)
          { :conditions => collector.clauses.to_conditions }
        }
      end
    end
  end
end

#extend ActiveRecord::Base with the where method 
ActiveRecord::Base.send :extend, RQuery::ActiveRecord::ClassMethods


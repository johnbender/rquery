$: << File.expand_path(File.dirname(__FILE__) + "/../lib/")

#RQuery is a small DSL for building queries in query languages like SQL. It is meant to be concise, easy to read
#and expressive.
#


require "rquery/serializers.rb"
require "rquery/logic_stub.rb"
require "rquery/declarations.rb"
require "rquery/adapters.rb"
require "rquery/active_record.rb"

module RQuery
    @@adapter = RQuery::Adapters::Sqlite
    
    #Allows for the runtime alteration of the adapter being used
    #to convert the "rqueries" into the adapters query language
    def RQuery.adapter=(val)
        @@adapter = val
    end
    def RQuery.adapter
        @@adapter
    end
end


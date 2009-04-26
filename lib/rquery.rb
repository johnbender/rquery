$: << File.expand_path(File.dirname(__FILE__) + "/../lib/")

#RQuery is a small DSL for building queries in query languages like SQL. It is meant to be concise, easy to read
#and expressive.

require "rquery/serializers.rb"
require "rquery/declarations.rb"
require "rquery/attribute.rb"
require "rquery/attribute_collection.rb"
require "rquery/adapters.rb"
require "rquery/active_record.rb"

module RQuery
  class << self 
    attr_accessor :adapter

    def use_symbols
      Symbol.send(:include, RQuery::Declarations)
    end
  
  end  
end

##default adapter
RQuery.adapter = RQuery::Adapters::Sqlite

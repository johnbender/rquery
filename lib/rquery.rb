$: << File.expand_path(File.dirname(__FILE__) + "/../lib/")

#RQuery is a small DSL for building queries in query languages like SQL. It is meant to be concise, easy to read
#and expressive.

require "rquery/operation_collector.rb"
require "rquery/attribute_collection.rb"
require "rquery/adapters.rb"
require "rquery/active_record.rb"

module RQuery
  class Config
    cattr_accessor :adapter
  end
end

##default adapter
RQuery::Config.adapter = RQuery::Adapters::Sqlite

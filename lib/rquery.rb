$: << File.expand_path(File.dirname(__FILE__) + "/../lib/")

require "rquery/serializers.rb"
require "rquery/declarations.rb"
require "rquery/adapters.rb"
require "rquery/active_record.rb"

module RQuery
    @@adapter = RQuery::Adapters::Sqlite
    def RQuery.adapter=(val)
        @@adapter = val
    end
    def RQuery.adapter
        @@adapter
    end
end


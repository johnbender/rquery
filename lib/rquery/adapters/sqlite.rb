
module RQuery
    module Adapters
        class Sqlite < Sql
            def self.contains
                "like '%' || ? || '%'"
            end
            def self.without
                "not #{contains}"
            end
        end
    end
end

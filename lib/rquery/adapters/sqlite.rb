
module RQuery
    module Adapters
        class Sqlite < Sql
            def self.contains
                "like '%' || ? || '%'"
            end
        end
    end
end

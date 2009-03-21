
module RQuery
    module Adapters
        class Sqlite < Sql
            def self.contains
                "like '%' || ? || '%'"
            end
            def self.not_contains
                "not #{contains}"
            end
        end
    end
end

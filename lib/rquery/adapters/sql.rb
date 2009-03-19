module RQuery
    module Adapters
        class Sql

            class << self
                def in
                    "in (?)" 
                end

                def not_in
                    #using send because 'in' is a keyword
                    "not #{send(:in)}"   
                end

                def between
                    "between ? and ?"
                end
                
                def not_between
                    "not #{between}"
                end

                def neq
                    "<> ?"
                end

                def ==
                    "= ?"
                end

                def contains
                    "like '%' + ? + '%'"
                end

                def join(ops)
                    ops.join(" and ")
                end

                [:>, :>=, :<, :<=].each do |operator|
                    define_method(operator) do 
                        "#{operator} ?"
                    end
                end
            end
        end
    end
end

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
                
                def and_group(ops)
                  "(#{ops.join(" and ")})"
                end

                def or_group(ops)
                  "(#{ops.join(" or ")})"
                end

                [:>, :>=, :<, :<=].each do |operator|
                    define_method(operator) do 
                        "#{operator} ?"
                    end
                end

                alias :join :and_group
            end
        end
    end
end

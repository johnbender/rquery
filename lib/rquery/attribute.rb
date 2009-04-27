module RQuery
  class Attribute
    #adds is, is_not, between, in, contains, and from (alias)
    include RQuery::Declarations

    #define name for the Declarations included methods
    #as it needs to be different than the default
    attr_accessor :name

    def initialize(field_name)
      @name = field_name
    end
  end
end

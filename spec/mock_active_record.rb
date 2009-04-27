module ActiveRecord
  class Base
    def Base.find(limit, conditions)
      [limit, conditions]
    end
  end
  
  class MockObject < Base
    def attribute_names
      ["foo"]
    end
  end
end

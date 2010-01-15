require 'rubygems'
require 'spec'
require 'spec/autorun'
require 'active_record'



module ClassMethods
  def find(limit, conditions)
    [limit, conditions]
  end
end

ActiveRecord::Base.send(:extend, ClassMethods)

class MockObject < ActiveRecord::Base
  def initialize
  end
  
  def attribute_names
    ["foo"]
  end
end


require 'rubygems'
require 'spec'
require 'spec/autorun'
require 'active_record'
require File.expand_path(File.dirname(__FILE__) + "/../lib/rquery.rb")

class MockObject < ActiveRecord::Base
  def self.find(limit, conditions)
    [limit, conditions]
  end
  
  def initialize
  end
  
  def attribute_names
    ["foo", "id"]
  end
end


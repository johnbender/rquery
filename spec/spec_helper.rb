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
  
  def self.columns
    [Column.new("foo"), Column.new("id")]
  end
end

class Column 
  attr_accessor :name
  def initialize(n)
    @name = n
  end
end


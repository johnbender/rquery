require File.expand_path(File.dirname(__FILE__) + "/spec_helper.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/rquery.rb")

describe ActiveRecord do

  before :all do
    RQuery::Config.adapter = RQuery::Adapters::Sqlite
    MockObject.sniper_scope :baz do  |object, foo_val|
      object.foo == foo_val
    end
  end
  
  it "should proved a named scope on the active record object when sniper_scope is defined" do
    MockObject.respond_to?(:baz).should == true
  end

  it "should set the named scope conditions properly when the sniper_scope is defined" do
    result = MockObject.baz('bar').proxy_options
    result.should == {:conditions => ['(foo = ?)', 'bar']}
  end
end

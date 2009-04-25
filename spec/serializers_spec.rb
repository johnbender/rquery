
require File.expand_path(File.dirname(__FILE__) + "/../lib/rquery.rb")

describe RQuery::Serializers do

  before(:all) do
    RQuery.use_symbols
  end

  it "Object.is should define ==, <, <=, >, >=, in, and between" do
    :foo.is.respond_to?(:==).should == true
    :foo.is.respond_to?(:<).should == true
    :foo.is.respond_to?(:<=).should == true
    :foo.is.respond_to?(:>).should == true
    :foo.is.respond_to?(:>=).should == true
    :foo.is.respond_to?(:in).should == true
    :foo.is.respond_to?(:between).should == true
  end

  it "Object.is_not should define == and in" do
    :foo.is_not.respond_to?(:==).should == true
    :foo.is_not.respond_to?(:in).should == true
    :foo.is_not.respond_to?(:between).should == true
  end

  it "Object.is_not should not redefine <, <=, >, >= in the same way that .is did" do
    lambda {:foo.is_not.send(:<)}.should raise_error(ArgumentError)
    lambda {:foo.is_not.send(:<=)}.should raise_error(ArgumentError)
    lambda {:foo.is_not.send(:>)}.should raise_error(ArgumentError)
    lambda {:foo.is_not.send(:>=)}.should raise_error(ArgumentError)
  end


end

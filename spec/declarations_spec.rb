
require File.expand_path(File.dirname(__FILE__) + "/../lib/rquery.rb")

describe RQuery::Declarations do

    before(:all) do
        RQuery.adapter = RQuery::Adapters::Sqlite
    end

    after(:each) do
        RQuery::Serializers::Operations.clear
    end

    it "any symbol should respond to is, is_not, in, between, from, and contains methods" do
        :foo.respond_to?(:is).should == true
        :foo.respond_to?(:is_not).should == true
        :foo.respond_to?(:in).should == true
        :foo.respond_to?(:from).should == true
        :foo.respond_to?(:between).should == true
        :foo.respond_to?(:from).should == true
    end

end

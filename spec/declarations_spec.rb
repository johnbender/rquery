
require File.expand_path(File.dirname(__FILE__) + "/../lib/rquery.rb")

describe RQuery::Declarations do

    before(:all) do
        RQuery.adapter = RQuery::Adapters::Sqlite
    end

    after(:each) do
        RQuery::Serializers::Operations.clear
    end

    it "any Object should respond to is, is_not, in, between, from, and contains methods" do
        :foo.respond_to?(:is).should == true
        :foo.respond_to?(:is_not).should == true
        :foo.respond_to?(:in).should == true
        :foo.respond_to?(:from).should == true
        :foo.respond_to?(:between).should == true
        :foo.respond_to?(:from).should == true
    end

    it "should return an Serializer Class when is, is_not are called" do
        :foo.is.class.should == Class
        :foo.is_not.class.should == Class
    end 

    it "should add an Operation for each call to is, is_not, and in" do
        :foo.is
        :bar.is
        RQuery::Serializers::Operations.conditions.should == ["foo and bar"]    
    end

    it "should add an Operation and the arguments for each call to from, contain, and between" do
        :foo.between 1,2
        RQuery::Serializers::Operations.conditions.should == ["foo between ? and ?", 1 , 2]
        RQuery::Serializers::Operations.clear 
        :bar.from 1,2 
        RQuery::Serializers::Operations.conditions.should == ["bar between ? and ?", 1 , 2]
        RQuery::Serializers::Operations.clear 
        :baz.contains "something" 
        RQuery::Serializers::Operations.conditions.should == ["baz like '%' || ? || '%'", "something"]
        RQuery::Serializers::Operations.clear 
    end


end

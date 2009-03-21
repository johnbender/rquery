
require File.expand_path(File.dirname(__FILE__) + "/../lib/rquery.rb")

describe RQuery::Adapters::Sqlite do

    before(:each) do
        #define the adapter with the new left operand
        @adapter = RQuery::Adapters::Sqlite
    end

    it "should return the correct sql for comparing :foo with non operator methods" do
        @adapter.in.should == "in (?)"
        @adapter.not_in.should == "not in (?)"
        @adapter.between.should == "between ? and ?"
        @adapter.not_between.should == "not " + @adapter.between
        @adapter.neq.should == "<> ?"
        @adapter.contains.should == "like '%' || ? || '%'"
        @adapter.not_contains.should == "not " + @adapter.contains 
    end


    it "should return the correct sql for comparing :foo with operators" do
        @adapter.send(:==).should == "= ?"
        @adapter.send(:>).should == "> ?"
        @adapter.send(:>=).should == ">= ?"
        @adapter.send(:<).should == "< ?"
        @adapter.send(:<=).should == "<= ?"
    end


end

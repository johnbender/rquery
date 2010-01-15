require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe RQuery::OperationCollector do

  before(:all) do
    RQuery::Config.adapter = RQuery::Adapters::Sqlite
  end

  it "should group two operations on the same line with parens and the 'or' keyword when the | operator is used" do

    MockObject.where{ |mock|
      (mock.foo == 2) | (mock.foo.in 1,2,3)
    }.should == [:all, {:conditions => ["((foo = ? or foo in (?)))", 2, [1,2,3]]}]

  end

  it "should group two operations on the same line with parns and the 'and' keyword when the & operator is used" do
    
    MockObject.where{ |mock|
      (mock.foo == 2) & (mock.foo.in 1,2,3)
    }.should == [:all, {:conditions => ["((foo = ? and foo in (?)))", 2, [1,2,3]]}]
    
  end

  it "should group two operations on the same line and continue to add subsequent operations" do

    MockObject.where{ |mock|
      (mock.foo == 2) & (mock.foo.in 1,2,3)
      mock.foo > 3
    }.should == [:all, {:conditions => ["((foo = ? and foo in (?)) and foo > ?)", 2, [1,2,3], 3]}]
    
  end

  it "should properly group multiple nested groupings on the same line" do

    MockObject.where{ |mock|
      (mock.foo == 2) | (mock.foo.in 1,2,3) | (mock.foo.contains "george")
      mock.foo > 3
      (mock.foo == 2) & (mock.foo.in 1,2,3)
    }.should == [:all, {:conditions => ["((foo = ? or foo in (?) or foo like '%' || ? || '%') and foo > ? and (foo = ? and foo in (?)))", 2, [1,2,3], "george", 3, 2, [1,2,3]]}]
    
  end

  it "& should have precedence when evaluating multiple operation group types on a single line" do
    
     MockObject.where{ |mock|
      (mock.foo == 2) | (mock.foo.in 1,2,3) & (mock.foo.contains "george")
    }.should == [:all, {:conditions => ["((foo = ? or (foo in (?) and foo like '%' || ? || '%')))", 2, [1,2,3], "george"]}]

  end

end

require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe ActiveRecord do

  before(:all) do
    RQuery::Config.adapter = RQuery::Adapters::Sqlite
  end

  it "should set up a where method" do
    MockObject.respond_to?(:where).should == true
  end

  it "should behave properly when using the id method" do
    MockObject.where { |mock|
      mock.id == 1
    }.should == [:all, {:conditions => ['(id = ?)', 1]}]
  end
  
  it "should return sql with foo, the operations, and the values for mock.foo <operation> <value>" do
    MockObject.where{ |mock|
      mock.foo == "bar"
      mock.foo = "bar"
    }.should == [:all, {:conditions => ["(foo = ? and foo = ?)", "bar", "bar"]}]  

    MockObject.where{ |mock|
      mock.foo > 1
    }.should == [:all, {:conditions => ["(foo > ?)", 1]}]

    MockObject.where{ |mock|
      mock.foo < 2
    }.should == [:all, {:conditions => ["(foo < ?)", 2]}]

    MockObject.where{ |mock|
      mock.foo >= 3
    }.should == [:all, {:conditions => ["(foo >= ?)", 3]}]

    MockObject.where{ |mock|
      mock.foo <= 4
    }.should == [:all, {:conditions => ["(foo <= ?)", 4]}]
  end

  it "should return sql with foo, the operations, and the values for mock.foo.not_<operation> <value>" do
    MockObject.where{ |mock|
      mock.foo.not = "bar"
    }.should == [:all, {:conditions => ["(foo <> ?)", "bar"]}]  

    MockObject.where{ |mock|
      mock.foo.not_in 1,2
    }.should == [:all, {:conditions => ["(foo not in (?))", [1,2]]}] 
    
    MockObject.where{ |mock|
      mock.foo.not_between 1..3
    }.should == [:all, {:conditions => ["(foo not between ? and ?)", 1, 3]}] 


    MockObject.where{ |mock|
      mock.foo.not_from 1..3
    }.should == [:all, {:conditions => ["(foo not between ? and ?)", 1, 3]}] 
    
     MockObject.where{ |mock|
      mock.foo.without "bar"
    }.should == [:all, {:conditions => ["(foo not like '%' || ? || '%')", "bar"]}]
  end

  it "should return sql with foo, the operations, and values for mock.foo.in and mock.foo.in when used with a list of args, array, and range" do
    resulting_conditions = [:all, {:conditions => ["(foo in (?))", [1,2,3,4]]}] 

    MockObject.where{ |mock|
      mock.foo.in 1,2,3,4
    }.should == resulting_conditions  

    MockObject.where{ |mock|
      mock.foo.in [1,2,3,4]
    }.should == resulting_conditions 

    MockObject.where{ |mock|
      mock.foo.in 1..4
    }.should == [:all, {:conditions => ["(foo in (?))", 1..4]}]  
    
    MockObject.where{ |mock|
      mock.foo.in 1,2,3,4
    }.should == resulting_conditions  

    MockObject.where{ |mock|
      mock.foo.in [1,2,3,4]
    }.should == resulting_conditions 

    MockObject.where{ |mock|
      mock.foo.in 1..4
    }.should == [:all, {:conditions => ["(foo in (?))", 1..4]}]  
  end

  it "should return sql with foo, operations, and values for mock.foo.between and mock.foo.between when used with a list of args, array, and range" do
    resulting_conditions = [:all, {:conditions => ["(foo between ? and ?)", 1, 2]}]

    MockObject.where{ |mock|
      mock.foo.between 1,2
    }.should == resulting_conditions

    MockObject.where{ |mock|
      mock.foo.between [1,2]
    }.should == resulting_conditions

    MockObject.where{ |mock|
      mock.foo.between 1..2
    }.should == resulting_conditions

    MockObject.where{ |mock|
      mock.foo.between 1,2
    }.should == resulting_conditions

    MockObject.where{ |mock|
      mock.foo.between [1,2]
    }.should == resulting_conditions
    
    MockObject.where{ |mock|
      mock.foo.between 1..2
    }.should == resulting_conditions
  end

  it "should return sql with foo, operations, and values for mock.foo.from when used with a list of args, array, and range" do
    resulting_conditions = [:all, {:conditions => ["(foo between ? and ?)", 1, 2]}]

    MockObject.where{ |mock|
      mock.foo.from 1,2
    }.should == resulting_conditions

    MockObject.where{ |mock|
      mock.foo.from [1,2]
    }.should == resulting_conditions

    MockObject.where{ |mock|
      mock.foo.from 1..2
    }.should == resulting_conditions

    MockObject.where{ |mock|
      mock.foo.from 1,2
    }.should == resulting_conditions

    MockObject.where{ |mock|
      mock.foo.from [1,2]
    }.should == resulting_conditions

    MockObject.where{ |mock|
      mock.foo.from 1..2
    }.should == resulting_conditions
  end

  it "should return sql with foo, operations, and values for mock.foo.contains when used with a range, array, and list" do
    resulting_conditions = [:all, {:conditions => ["(foo like '%' || ? || '%')", "bar"]}]

    MockObject.where{ |mock|
      mock.foo.contains "bar"
    }.should == resulting_conditions
  end

  it "should return return the correct group of joined sql after multiple operations" do
    MockObject.where{ |mock|
      mock.foo == "bar"
      mock.foo.not_in 1,2,3,4,5 
    }.should == [:all, {:conditions => ["(foo = ? and foo not in (?))", "bar", [1,2,3,4,5]]}]
  end

  it "should return return the correct limit value passed" do
    MockObject.where(:first){ |mock|
      mock.foo == "bar"
      mock.foo.not_in 1,2,3,4,5 
    }.should == [:first, {:conditions => ["(foo = ? and foo not in (?))", "bar", [1,2,3,4,5]]}]
  end

  it "should have the correct 'not' keywords in alternating operations" do
    MockObject.where(:first){ |mock| 
      mock.foo == "bar"
      mock.foo.not_in 1,2,3,4,5 
      mock.foo > 3
    }.should == [:first, {:conditions => ["(foo = ? and foo not in (?) and foo > ?)", "bar", [1,2,3,4,5], 3]}]
  end

  it "should return return strings as arguments when passed to between, in, and from (used for date strings)" do
    MockObject.where{ |mock|
      mock.foo.between "some string", "2007-01-01"
    }.should == [:all, {:conditions => ["(foo between ? and ?)", "some string", "2007-01-01"]}]

    MockObject.where{ |mock|
      mock.foo.not_between "some string", "2007-01-01"
    }.should == [:all, {:conditions => ["(foo not between ? and ?)", "some string", "2007-01-01"]}]

    MockObject.where{ |mock|
      mock.foo.from "some string", "2007-01-01"
    }.should == [:all, {:conditions => ["(foo between ? and ?)", "some string", "2007-01-01"]}]
    
    MockObject.where{ |mock|
      mock.foo.in "some string", "2007-01-01"
    }.should == [:all, {:conditions => ["(foo in (?))", ["some string", "2007-01-01"]]}]
  end

  it "should throw and exception when trying to use a field not in the objects attributes" do    
    attribute = "arbitrary_attribute_name"
    lambda { MockObject.where{ |mock| mock.send(attribute) == 2 }}.should raise_error(NoMethodError)
  end
end

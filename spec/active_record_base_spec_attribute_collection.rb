require File.expand_path(File.dirname(__FILE__) + "/mock_active_record.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/rquery.rb")

describe ActiveRecord do

  before(:all) do
    RQuery.adapter = RQuery::Adapters::Sqlite
  end

  #should really set up the find method defined above to use the ruby db libraries and 
  #create the final sql string
  #all run with default adapter

  it "should set up a where method" do
    ActiveRecord::MockObject.respond_to?(:where).should == true
  end
  
  it "should return sql with foo, the operations, and the values for mock.foo.is <operation> <value>" do
    
    ActiveRecord::MockObject.where{ |mock|
      mock.foo.is == "bar"
    }.should == [:all, {:conditions => ["(foo = ?)", "bar"]}]  

    ActiveRecord::MockObject.where{ |mock|
      mock.foo.is > 1
    }.should == [:all, {:conditions => ["(foo > ?)", 1]}]

    ActiveRecord::MockObject.where{ |mock|
      mock.foo.is < 2
    }.should == [:all, {:conditions => ["(foo < ?)", 2]}]

    ActiveRecord::MockObject.where{ |mock|
      mock.foo.is >= 3
    }.should == [:all, {:conditions => ["(foo >= ?)", 3]}]

    ActiveRecord::MockObject.where{ |mock|
      mock.foo.is <= 4
    }.should == [:all, {:conditions => ["(foo <= ?)", 4]}]

  end

  it "should return sql with foo, the operations, and the values for mock.foo.is_not <operation> <value>" do
    ActiveRecord::MockObject.where{ |mock|
      mock.foo.is_not == "bar"
    }.should == [:all, {:conditions => ["(foo <> ?)", "bar"]}]  

    ActiveRecord::MockObject.where{ |mock|
      mock.foo.is_not.in 1,2
    }.should == [:all, {:conditions => ["(foo not in (?))", [1,2]]}] 
    
    ActiveRecord::MockObject.where{ |mock|
      mock.foo.is_not.between 1..3
    }.should == [:all, {:conditions => ["(foo not between ? and ?)", 1, 3]}] 

    ActiveRecord::MockObject.where{ |mock|
      mock.foo.is_not.from 1..3
    }.should == [:all, {:conditions => ["(foo not between ? and ?)", 1, 3]}] 

  end

  it "should return sql with foo, the operations, and values for mock.foo.is.in and mock.foo.in when used with a list of args, array, and range" do
    
    resulting_conditions = [:all, {:conditions => ["(foo in (?))", [1,2,3,4]]}] 

    ActiveRecord::MockObject.where{ |mock|
      mock.foo.is.in 1,2,3,4
    }.should == resulting_conditions  

    ActiveRecord::MockObject.where{ |mock|
      mock.foo.is.in [1,2,3,4]
    }.should == resulting_conditions 

    ActiveRecord::MockObject.where{ |mock|
      mock.foo.is.in 1..4
    }.should == [:all, {:conditions => ["(foo in (?))", 1..4]}]  
    
    ActiveRecord::MockObject.where{ |mock|
      mock.foo.in 1,2,3,4
    }.should == resulting_conditions  

    ActiveRecord::MockObject.where{ |mock|
      mock.foo.in [1,2,3,4]
    }.should == resulting_conditions 

    ActiveRecord::MockObject.where{ |mock|
      mock.foo.in 1..4
    }.should == [:all, {:conditions => ["(foo in (?))", 1..4]}]  

  end

  it "should return sql with foo, operations, and values for mock.foo.is.between and mock.foo.between when used with a list of args, array, and range" do

    resulting_conditions = [:all, {:conditions => ["(foo between ? and ?)", 1, 2]}]

    ActiveRecord::MockObject.where{ |mock|
      mock.foo.is.between 1,2
    }.should == resulting_conditions

    ActiveRecord::MockObject.where{ |mock|
      mock.foo.is.between [1,2]
    }.should == resulting_conditions

    ActiveRecord::MockObject.where{ |mock|
      mock.foo.is.between 1..2
    }.should == resulting_conditions

    ActiveRecord::MockObject.where{ |mock|
      mock.foo.between 1,2
    }.should == resulting_conditions

    ActiveRecord::MockObject.where{ |mock|
      mock.foo.between [1,2]
    }.should == resulting_conditions
    
    ActiveRecord::MockObject.where{ |mock|
      mock.foo.between 1..2
    }.should == resulting_conditions

  end

  it "should return sql with foo, operations, and values for mock.foo.is.from when used with a list of args, array, and range" do

    resulting_conditions = [:all, {:conditions => ["(foo between ? and ?)", 1, 2]}]

    ActiveRecord::MockObject.where{ |mock|
      mock.foo.is.from 1,2
    }.should == resulting_conditions

    ActiveRecord::MockObject.where{ |mock|
      mock.foo.is.from [1,2]
    }.should == resulting_conditions

    ActiveRecord::MockObject.where{ |mock|
      mock.foo.is.from 1..2
    }.should == resulting_conditions

    ActiveRecord::MockObject.where{ |mock|
      mock.foo.from 1,2
    }.should == resulting_conditions

    ActiveRecord::MockObject.where{ |mock|
      mock.foo.from [1,2]
    }.should == resulting_conditions

    ActiveRecord::MockObject.where{ |mock|
      mock.foo.from 1..2
    }.should == resulting_conditions


  end

  it "should return sql with foo, operations, and values for mock.foo.contains when used with a range, array, and list" do

    resulting_conditions = [:all, {:conditions => ["(foo like '%' || ? || '%')", "bar"]}]

    ActiveRecord::MockObject.where{ |mock|
      mock.foo.contains "bar"
    }.should == resulting_conditions

  end


  it "should return return the correct group of joined sql after multiple operations" do
    
    ActiveRecord::MockObject.where{ |mock|
      mock.foo.is == "bar"
      mock.foo.is_not.in 1,2,3,4,5 
    }.should == [:all, {:conditions => ["(foo = ? and foo not in (?))", "bar", [1,2,3,4,5]]}]

  end

  it "should return return the correct limit value passed" do
    
    ActiveRecord::MockObject.where(:first){ |mock|
      mock.foo.is == "bar"
      mock.foo.is_not.in 1,2,3,4,5 
    }.should == [:first, {:conditions => ["(foo = ? and foo not in (?))", "bar", [1,2,3,4,5]]}]

  end

  it "should have the correct 'not' keywords in alternating operations" do

    ActiveRecord::MockObject.where(:first){ |mock| 
      mock.foo.is == "bar"
      mock.foo.is_not.in 1,2,3,4,5 
      mock.foo.is > 3
    }.should == [:first, {:conditions => ["(foo = ? and foo not in (?) and foo > ?)", "bar", [1,2,3,4,5], 3]}]

  end

  it "should return return strings as arguments when passed to between, in, and from (used for date strings)" do
    
    ActiveRecord::MockObject.where{ |mock|
      mock.foo.is.between "some string", "2007-01-01"
    }.should == [:all, {:conditions => ["(foo between ? and ?)", "some string", "2007-01-01"]}]

    ActiveRecord::MockObject.where{ |mock|
      mock.foo.is_not.between "some string", "2007-01-01"
    }.should == [:all, {:conditions => ["(foo not between ? and ?)", "some string", "2007-01-01"]}]

    ActiveRecord::MockObject.where{ |mock|
      mock.foo.is.from "some string", "2007-01-01"
    }.should == [:all, {:conditions => ["(foo between ? and ?)", "some string", "2007-01-01"]}]
    
    ActiveRecord::MockObject.where{ |mock|
      mock.foo.in "some string", "2007-01-01"
    }.should == [:all, {:conditions => ["(foo in (?))", ["some string", "2007-01-01"]]}]

  end

  it "should throw and exception when trying to use a field not in the objects attributes" do    
    attribute = "arbitrary_attribute_name"
    lambda { ActiveRecord::MockObject.where{ |mock| mock.send(attribute).is == 2 }}.should raise_error(RQuery::AttributeNotFoundError)
  end

end

require File.expand_path(File.dirname(__FILE__) + "/mock_active_record.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/rquery.rb")

describe ActiveRecord do

  before(:all) do
    RQuery::Config.adapter = RQuery::Adapters::Sqlite
  end

  it "should set up a where method" do
    ActiveRecord::MockObject.respond_to?(:where).should == true
  end
  
  it "should return sql with foo, the operations, and the values for mock.foo <operation> <value>" do
    
    ActiveRecord::MockObject.where{ |mock|
      mock.foo == "bar"
    }.should == [:all, {:conditions => ["(foo = ?)", "bar"]}]  

    ActiveRecord::MockObject.where{ |mock|
      mock.foo > 1
    }.should == [:all, {:conditions => ["(foo > ?)", 1]}]

    ActiveRecord::MockObject.where{ |mock|
      mock.foo < 2
    }.should == [:all, {:conditions => ["(foo < ?)", 2]}]

    ActiveRecord::MockObject.where{ |mock|
      mock.foo >= 3
    }.should == [:all, {:conditions => ["(foo >= ?)", 3]}]

    ActiveRecord::MockObject.where{ |mock|
      mock.foo <= 4
    }.should == [:all, {:conditions => ["(foo <= ?)", 4]}]

  end

  it "should return sql with foo, the operations, and the values for mock.foo.not_<operation> <value>" do
    ActiveRecord::MockObject.where{ |mock|
      mock.foo.not = "bar"
    }.should == [:all, {:conditions => ["(foo <> ?)", "bar"]}]  

    ActiveRecord::MockObject.where{ |mock|
      mock.foo.not_in 1,2
    }.should == [:all, {:conditions => ["(foo not in (?))", [1,2]]}] 
    
    ActiveRecord::MockObject.where{ |mock|
      mock.foo.not_between 1..3
    }.should == [:all, {:conditions => ["(foo not between ? and ?)", 1, 3]}] 

    ActiveRecord::MockObject.where{ |mock|
      mock.foo.not_from 1..3
    }.should == [:all, {:conditions => ["(foo not between ? and ?)", 1, 3]}] 
    
     ActiveRecord::MockObject.where{ |mock|
      mock.foo.without "bar"
    }.should == [:all, {:conditions => ["(foo not like '%' || ? || '%')", "bar"]}]

  end

  it "should return sql with foo, the operations, and values for mock.foo.in and mock.foo.in when used with a list of args, array, and range" do
    
    resulting_conditions = [:all, {:conditions => ["(foo in (?))", [1,2,3,4]]}] 

    ActiveRecord::MockObject.where{ |mock|
      mock.foo.in 1,2,3,4
    }.should == resulting_conditions  

    ActiveRecord::MockObject.where{ |mock|
      mock.foo.in [1,2,3,4]
    }.should == resulting_conditions 

    ActiveRecord::MockObject.where{ |mock|
      mock.foo.in 1..4
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

  it "should return sql with foo, operations, and values for mock.foo.between and mock.foo.between when used with a list of args, array, and range" do

    resulting_conditions = [:all, {:conditions => ["(foo between ? and ?)", 1, 2]}]

    ActiveRecord::MockObject.where{ |mock|
      mock.foo.between 1,2
    }.should == resulting_conditions

    ActiveRecord::MockObject.where{ |mock|
      mock.foo.between [1,2]
    }.should == resulting_conditions

    ActiveRecord::MockObject.where{ |mock|
      mock.foo.between 1..2
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

  it "should return sql with foo, operations, and values for mock.foo.from when used with a list of args, array, and range" do

    resulting_conditions = [:all, {:conditions => ["(foo between ? and ?)", 1, 2]}]

    ActiveRecord::MockObject.where{ |mock|
      mock.foo.from 1,2
    }.should == resulting_conditions

    ActiveRecord::MockObject.where{ |mock|
      mock.foo.from [1,2]
    }.should == resulting_conditions

    ActiveRecord::MockObject.where{ |mock|
      mock.foo.from 1..2
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
      mock.foo == "bar"
      mock.foo.not_in 1,2,3,4,5 
    }.should == [:all, {:conditions => ["(foo = ? and foo not in (?))", "bar", [1,2,3,4,5]]}]

  end

  it "should return return the correct limit value passed" do
    
    ActiveRecord::MockObject.where(:first){ |mock|
      mock.foo == "bar"
      mock.foo.not_in 1,2,3,4,5 
    }.should == [:first, {:conditions => ["(foo = ? and foo not in (?))", "bar", [1,2,3,4,5]]}]

  end

  it "should have the correct 'not' keywords in alternating operations" do

    ActiveRecord::MockObject.where(:first){ |mock| 
      mock.foo == "bar"
      mock.foo.not_in 1,2,3,4,5 
      mock.foo > 3
    }.should == [:first, {:conditions => ["(foo = ? and foo not in (?) and foo > ?)", "bar", [1,2,3,4,5], 3]}]

  end

  it "should return return strings as arguments when passed to between, in, and from (used for date strings)" do
    
    ActiveRecord::MockObject.where{ |mock|
      mock.foo.between "some string", "2007-01-01"
    }.should == [:all, {:conditions => ["(foo between ? and ?)", "some string", "2007-01-01"]}]

    ActiveRecord::MockObject.where{ |mock|
      mock.foo.not_between "some string", "2007-01-01"
    }.should == [:all, {:conditions => ["(foo not between ? and ?)", "some string", "2007-01-01"]}]

    ActiveRecord::MockObject.where{ |mock|
      mock.foo.from "some string", "2007-01-01"
    }.should == [:all, {:conditions => ["(foo between ? and ?)", "some string", "2007-01-01"]}]
    
    ActiveRecord::MockObject.where{ |mock|
      mock.foo.in "some string", "2007-01-01"
    }.should == [:all, {:conditions => ["(foo in (?))", ["some string", "2007-01-01"]]}]

  end

  it "should throw and exception when trying to use a field not in the objects attributes" do    
    attribute = "arbitrary_attribute_name"
    lambda { ActiveRecord::MockObject.where{ |mock| mock.send(attribute) == 2 }}.should raise_error(RQuery::AttributeNotFoundError)
  end

end

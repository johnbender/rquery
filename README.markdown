
RQuery
======

RQuery is a small DSL inspired by RSpec for building text queries in languages like SQL. It is meant to be concise, easy to read, and expressive about what the query will be asking for.

Currently only the ActiveRecord extension is implemented with a Sqlite adapter. Mysql should be trivial to implement, and I'm hoping to get to supporting my own project Grove.

ActiveRecord
------------

###Setup/Config and Symbols vs Block parameters

In you're rails environment file simply require rquery. The default adapter is the included Sqlite adapter but you can created and set your own with

    RQuery.adapter = class 

You can view both Sql and Sqlite in the adapters directory if you are interested in writing your own (mysql?). As a side note it would be nice at some point to decide the adapter based on the db chosen for a given environment.

Also, you can choose to use symbols as the attribute names in the block or you can use an option block argument to represent an ActiveRecord object. To use the symbols make sure to add the following to your environment.rb

    RQuery.use_symbols

Using the block parameter instead has two benefits. 1: you won't be poluting the Symbol objects with my hackery, and 2: RQuery will tell you when you are attempting use an attribute for the object that doesn't exist. Examples of both below.

###Examples

RQuery extend ActiveRecord to provide the `where` method. `where` accepts a single optional argument and a block that represents the query statements

In a given UsersController your `show` action might find the User like so:

    @user = User.find(params[:id])

Using RQuery:

    @user = User.where { :id.is == params[:id] }

Or

    @user = User.where { |user| user.id.is == params[:id] }

In the above case, RQuery doesn't provide much of an improvement over the traditional `find` method, but as the query becomes more complex its expressiveness begins to shine through:

    @users = User.find(:all, conditions => ["age between ? and ?", 10 , 20])

RQuery:

    @users = User.where do 
        :age.from 10..20 
    end

Or:

    @users = User.where do |user|
        user.age.between 10..20 
    end

Both the `from` and `between` methods accept argument lists `10,20` or an array `[10,20]`. 

###Other Examples 

RQuery supports most of the common SQL operations: =, <>, >, <, >=, <=  as well as in, like (see below for specifics), and between. `:column.is_not` works for `.in`, `.between`, `.contains`, and `==`. All operations are anded as of the current version.

Operators:

    @obj = ActiveRecordObject.where do |obj|
        obj.foo.is > 2      
        obj.foo.is_not == 4 
    end 

    #=> conditions array: ["foo > ? and foo <> ?", 2, 4]

Contains:

    @obj = ActiveRecordObject.where do
        :foo.contains "bar"
    end
    #=> conditions array: ["foo like '%' || ? || '%'", "bar"]
    #using the default sqlite adapter

In:

   @obj = ActiveRecordObject.where do |obj|
        obj.foo.in "bar", "baz", "bak"
    end
    #=> conditions array: ["foo in (?)", ["bar", "baz", "bak"]]
    #using the default sqlite adapter


You can also limit the results returned in a similar manner to the `find` method by passing a symbol argument to the where method. The default is `:all`, when no option is specified.

First:

    @obj = ActiveRecordObject.where(:first) do
        :foo.is == "bar"
    end

is equivalent to the find call:

    @obj = ActiveRecordObject.find(:first, conditions => ["foo = ?", "bar"])

###Complex queries

RQuery supports relatively complex queries including | and & operation groupings. All operations need to be on the same line and in parens and either the | operator or the & operator can be used on a singel line

    User.where do |user|
        (mock.age.is > 20) | (mock.age.in 16,18)
    end

In the following example the & takes precedence and will be grouped with the contains "Alice" which will be or'd with the contains "George" 

    #=> name contains "George" or (name contains "Alice and age from 20 to 30)
    User.where do |user|
        (user.name.contains "George") | (user.name.contains "Alice") & (use.age.from 20..30)
    end

To correct the above to the more intuitive version add parens to force precedence of the contains operations 
    
    #=> (name contains "George" or name contains "Alice) and age from 20 to 30
    User.where do |user|
        ((user.name.contains "George") | (user.name.contains "Alice")) & (use.age.from 20..30)
    end

In this sutation it would be cleaner and easier to just move the and'd statement down a line as all seperate lines are and'd and lines have precedence from top to bottom
    
    User.where do |user|
        (user.name.contains "George") | (user.name.contains "Alice")
        use.age.from 20..30
    end





    

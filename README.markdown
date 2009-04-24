RQuery
======

RQuery is a small DSL inspired by RSpec for building text queries in languages like SQL. It is meant to be concise, easy to read, and expressive about what the query will be asking for.

Currently only the ActiveRecord extension is implemented with a Sqlite adapter. Mysql should follow shortly, and then support for Grove + JSON queries to Mnesia.

ActiveRecord
------------

RQuery extend ActiveRecord to provide the `where` method. `where` accepts a single optional argument and a block that represents the query statements

###Example compared with `find`

In a given UsersController your `show` action might find the User like so:

    @user = User.find(params[:id])

Using RQuery:

    @user = User.where { :id.is == params[:id] }


In the above case, RQuery doesn't provide much of an improvement over the traditional `find` method, but as the query becomes more complex its expressiveness begins to shine through:

    @users = User.find(:all, conditions => ["age between ? and ?", 10 , 20])

RQuery:

    @users = User.where do 
        :age.from 10..20 
    end

Or:

    @users = User.where do 
        :age.between 10..20 
    end

Both the `from` and `between` methods accept argument lists `10,20` or an array `[10,20]`. 


###Other Examples 

RQuery supports most of the common SQL operations: =, <>, >, <, >=, <=  as well as in, like (see below for specifics), and between. `:column.is_not` works for `.in`, `.between`, `.contains`, and `==`. All operations are anded as of the current version.

Operators:

    @obj = ActiveRecordObject.where do
        :foo.is > 2      
        :foo.is_not == 4 
    end 
    #=> conditions array: ["foo > ? and foo <> ?", 2, 4]

Contains:

    @obj = ActiveRecordObject.where do
        :foo.contains "bar"
    end
    #=> conditions array: ["foo like '%' || ? || '%'", "bar"]
    #using the default sqlite adapter

In:

   @obj = ActiveRecordObject.where do
        :foo.in "bar", "baz", "bak"
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




    

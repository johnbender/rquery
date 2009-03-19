RQuery
======

RQuery is a small DSL inspired by RSpec for building text queries in languages like SQL. It is meant to be concise, easy to read, and expressive about what the query will be asking for.

Currently only the ActiveRecord extension is implemented.

ActiveRecord
------------

RQuery can extend ActiveRecord to provide the `where` method. `where` accepts a single optional argument and a block that represents the query statements

###Example

In a given UsersController your `show` action might find the User like so:

    @user = User.find(params[:id])

Using RQuery:

    @user = User.where { :id.is == params[:id] }


In the above case, RQuery doesn't provide much of an improvement over the traditional `find` method, but as the query becomes more complex its expressiveness begins to shine through:

    @users = User.find(:all, conditions => ["age between ? and ?", params[:start_age], params[:finish_age]])

RQuery:

    @users = User.where do 
        :age.between params[:start_age], params[:finish_age]
    end




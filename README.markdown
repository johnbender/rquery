RQuery
======

RQuery is a small DSL inspired by RSpec for building text queries in languages like SQL. It is meant to be concise, easy to read, and expressive about what the query will be asking for.

Currently only the ActiveRecord extension is implemented.

ActiveRecord
------------

RQuery can extend ActiveRecord to provide the `where` method. `where` accepts a single optional argument and a block that represents the query statements

###Example

In a UsersController generally your `show` action might look something like:

  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event }
    end
  end

Using RQuery:

  def show
    @user = User.where { :id.is == params[:id] }

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event }
    end
  end




#All operations need to be on the same line and in parens
#either the | operator or the & operator can be used on a singel line
User.where do |user|
  (mock.age.is > 20) | (mock.age.in 16,18)
end

#the & takes precedence here and will be grouped with the contains "Alice" which will be 
#or'd with the contains "George" 
#=> name contains "George" or (name contains "Alice and age from 20 to 30)
User.where do |user|
  (user.name.contains "George") | (user.name.contains "Alice") & (use.age.from 20..30)
end

#to correct the above to the more intuitive version add parens to force precedence of the
#contains operations 
#=> (name contains "George" or name contains "Alice) and age from 20 to 30
User.where do |user|
 ((user.name.contains "George") | (user.name.contains "Alice")) & (use.age.from 20..30)
end

#in this sutation it would be cleaner and easier to just move the and'd statement down
#a line as all seperate lines are and'd and lines have precedence from top to bottom
#additionaly operations on seperate lines don't need parens
User.where do |user|
 (user.name.contains "George") | (user.name.contains "Alice")
 use.age.from 20..30
end

#should you attempt to use and attribute that doesn't exist for a given model
#rquery will tell you before it's sent to the db
User.where do |user|
  user.ssn.is == 123-45-6789
end
# RQuery::AttributeNotFoundError: The field 'ssn' doesn't exist for this object
# 	from /Users/johnbender/Projects/rquery/lib/rquery/attribute_collection.rb:28:in `method_missing'
# 	from (irb):24
# 	from /Users/johnbender/Projects/rquery/lib/rquery/active_record/base.rb:16:in `where'
# 	from /Users/johnbender/Projects/rquery/lib/rquery/active_record/base.rb:11:in `synchronize'
# 	from /Users/johnbender/Projects/rquery/lib/rquery/active_record/base.rb:11:in `where'
# 	from (irb):23

#environment config
RQuery.use_symbols

#example of using symbols, you can see more at the RQuery page on my site.
User.where do |user|
 (:name.contains "George") | (:name.contains "Alice")
 :age.from 20..30
end

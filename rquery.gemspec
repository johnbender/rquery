Gem::Specification.new do |s|
  s.name        = "rquery"
  s.version     = "0.3.0"
  s.date        = "2009-08-22"
  
  s.summary     = "An ActiveRecord extension providing a DSL replacement for complex find queries."
  s.description = ""
 
  s.authors     = [ "John bender" ]
  s.email       = "john.m.bender@gmail.com"
  s.homepage    = "http://github.com/johnbender/rquery"
 
  s.has_rdoc    = false
  
  s.files       = %w(

    README.markdown
    rakefile.rb
    lib/rquery.rb
    lib/rquery/attribute_collection.rb
    lib/rquery/active_record.rb
    lib/rquery/active_record/base.rb
    lib/rquery/adapters.rb
    lib/rquery/adapters/sql.rb
    lib/rquery/adapters/sqlite.rb
    lib/rquery/operation_collector.rb
    spec/active_record_base_spec_attribute_collection.rb
    spec/mock_active_record.rb
    spec/or_and_operations_spec.rb
    spec/sqlite_adapter_spec.rb
    )   
  
end
 



Gem::Specification.new do |s|
  s.name        = "rquery"
  s.version     = "0.1.0"
  s.date        = "2000-03-16"
  
  s.summary     = "A ruby DSL for building data queries in SQL and other query languages."
  s.description = ""
 
  s.authors     = [ "John bender" ]
  s.email       = "john.bender@gmail.com"
  s.homepage    = "http://nickelcode.com/rquery/"
 
  s.has_rdoc    = false
  
  s.files       = %w(
    
    rakefile.rb
    lib/rquery.rb
    lib/rquery/declarations.rb
    lib/rquery/serializers.rb
    lib/rquery/active_record.rb
    lib/rquery/active_record/base.rb
    lib/rquery/adapters.rb
    lib/rquery/sql.rb
    lib/rquery/sqlite.rb
    spec/active_record_base_spec.rb	
    spec/serializers_spec.rb
    spec/declarations_spec.rb		
    spec/sqlite_adapter_spec.rb
  )
end
 


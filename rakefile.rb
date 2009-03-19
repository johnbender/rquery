task :default => :test

task :test do
      require File.dirname(__FILE__) + '/test/all_tests.rb'  
end

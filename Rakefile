require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "is_positionable"
    gem.summary = %Q{Handles positioning (ordering) your ActiveRecord Objects.}
    gem.description = %Q{
                          Handles positioning (ordering) your ActiveRecord Objects.
                          Makes use of the "Acts As List" plugin for the optimized background handling of the positioning.
                          "Is Positionable" is a front-end that dynamically generates buttons for moving ActiveRecord Objects
                          "up", "down", to the "top" and to the "bottom". Setting it up takes just 1 word: "is_positionable".
                        }
    gem.email = "meskyan@gmail.com"
    gem.homepage = "http://github.com/meskyanichi/is_positionable"
    gem.authors = ["meskyanichi"]
    gem.add_dependency "acts_as_list"
#    gem.files.include 'lib/**/*'
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/*_test.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION')
    version = File.read('VERSION')
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "ip #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

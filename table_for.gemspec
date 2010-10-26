require 'table_for/version'

spec = Gem::Specification.new do |s|
  s.authors           = ["Dima Lunich", "Andrey Savchenko"]
  s.email             = ["dima.lunich@gmail.com", "andrey@aejis.eu"]
  s.date              = "2010-10-24"
  s.homepage          = "http://github.com/lunich/table_for"
  s.rubyforge_project = ""
  s.name              = TableHelper::GEM_NAME
  s.version           = TableHelper::VERSION
  s.summary           = "#{TableHelper::GEM_NAME}-#{TableHelper::VERSION}"
  s.description       = "This gem builds HTML-table using given array"
  s.files             = Dir.glob("{lib,spec}/**/*") +
    ["README.rdoc", "Rakefile", "Changelog", "Gemfile", "init.rb"]
  
  s.test_files        = [
    "spec/table_for_spec.rb",
    "spec/table_for_spec.rb"
  ]
  s.require_path      = "lib"
  s.extra_rdoc_files  = ["README.rdoc"]
  s.rdoc_options = ["--main", "README.rdoc"]
  
  s.add_development_dependency "rspec"
  s.add_dependency "rails"
end

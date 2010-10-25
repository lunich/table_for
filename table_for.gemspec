spec = Gem::Specification.new do |s|
  s.authors           = ["Dima Lunich", "Andrey Savchenko"]
  s.email             = ["dima.lunich@gmail.com", "andrey@aejis.eu"]
  s.date              = "2010-10-24"
  s.homepage          = "http://github.com/lunich/table_for"
  s.rubyforge_project = ""
  s.name              = "table_for"
  s.version           = "0.1"
  s.summary           = "table_for-0.1"
  s.description       = "This gem builds HTML-table using given array"
  s.files             = [
    "README.rdoc", "Rakefile", "Changelog", "Gemfile", "init.rb",
    "lib/table_for.rb",
    "spec/table_for_spec.rb", "spec/table_for_spec.rb"
  ]
  s.test_files        = [
    "spec/table_for_spec.rb",
    "spec/table_for_spec.rb"
  ]
  s.require_path      = "lib"
  s.extra_rdoc_files  = ["README.rdoc"]
  
  s.add_development_dependency "rspec"
  s.add_dependency "rails"
end

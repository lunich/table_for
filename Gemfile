source :gemcutter

gem "actionpack"

group :development, :test do
  gem "rspec", ">=2.0.0"
  gem "autotest"
  gem "webrat"

  case RUBY_VERSION
  when /^1\.9/
    gem 'ruby-debug19'
  when /^1\.8/
    gem 'ruby-debug'
  end
end

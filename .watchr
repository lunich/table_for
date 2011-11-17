# -*- encoding : utf-8 -*-
require 'colorize'
def run_spec(file)
  unless File.exist?(file)
    puts "#{file} does not exist"
    return
  end

  puts "Running #{file}".green
  system %{bundle exec rspec #{file}}
  puts
end

def run_specs(files)
  puts "Running #{files.size} file(s):\n"
  puts files.map { |f| "#{f}" }.join("\n").green
  system %{bundle exec rspec #{files.join(" ")}}
end

def run_dependent_specs(model)
  plurals = {
    "news" => "news",
  }
  plural = plurals[model] || "#{model}s"
  specs = []
  specs += Dir.glob("spec/controllers/**/#{plural}_controller_spec.rb")
  specs += Dir.glob("spec/helpers/**/#{plural}_helper_spec.rb")
  specs += Dir.glob("spec/models/#{model}_spec.rb")
  specs += Dir.glob("spec/requests/**/*#{plural}_spec.rb")
  specs += Dir.glob("spec/routing/**/#{plural}_routing_spec.rb")
  specs += Dir.glob("spec/views/**/#{plural}/*_spec.rb")
  run_specs(specs)
end

def run_all_specs
  system "bundle exec rspec #{Dir.glob("spec/{controllers,helpers,lib,models,requests,routing,views}/**/*_spec.rb").join(" ")}"
end

watch("^spec/(.*)_spec\.rb$") { |match| run_spec match[0] }
watch("^lib/(.*)\.rb$") { |match| run_spec %{spec/#{match[1]}_spec.rb} }

# --------------------------------------------------
# Signal Handling
# --------------------------------------------------
# Ctrl-\
Signal.trap('QUIT') do
  puts " --- Running all tests ---\n\n"
  run_all_specs
end

# Ctrl-C
Signal.trap('INT') { abort("\n") }

require "colorize"
puts "Watching...".yellow

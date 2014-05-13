require "bundler/gem_tasks"
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.fail_on_error = true
  t.verbose = true
  t.rspec_opts = ["-r ./spec/spec_helper", "--color"]
end

task default: :spec

desc "open console (require 'puggle')"
task :c do
  system "irb -I lib -r puggle"
end

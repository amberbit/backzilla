require 'bundler'
require 'rake'
require 'spec/rake/spectask'

desc 'Default: run Specs.'
task :default => :spec

desc 'Run specs'
Spec::Rake::SpecTask.new(:spec) do |t|
  t.libs << 'lib'
  t.verbose = true
end

Bundler::GemHelper.install_tasks

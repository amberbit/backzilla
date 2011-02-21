require 'rake'
require 'rake/rdoctask'
require 'spec/rake/spectask'
require 'rubygems'
desc 'Default: run Specs.'
task :default => :spec


desc 'Run specs'
Spec::Rake::SpecTask.new(:spec) do |t|
  t.libs << 'lib'
  t.verbose = true
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "backzilla"
    gemspec.summary = "Multi-purpose backup tool"
    gemspec.description = "Backzilla can backup multiple entities to multiple destinations."
    gemspec.email = "pawel.sobolewski@amberbit.com"
    gemspec.homepage = "http://amberbit.com/"
    gemspec.authors = ["Wojtek Piekutowski, Paweł Sobolewski"]
  end
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end


# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "backzilla/version"

Gem::Specification.new do |s|
  s.name        = "backzilla"
  s.version     = Backzilla::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Wojciech Piekutowski, Paweł Sobolewski, Łukasz Mieczkowski"]
  s.email       = ["code@amberbit.com"]
  s.homepage    = "https://github.com/amberbit/backzilla"
  s.summary     = %q{Backzilla is a multi-purpose backup tool based on duplicity (http://duplicity.nongnu.org)}
  s.description = %q{Backzilla is a multi-purpose backup tool based on duplicity (http://duplicity.nongnu.org)}

  s.rubyforge_project = "backzilla"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec-core"
  s.add_development_dependency "rspec-mocks"
  s.add_development_dependency "rspec-expectations"
  s.add_development_dependency "rspec", "1.3.1"
  s.add_dependency "net-sftp", "~>2.0.0" 
  s.add_dependency "open4", "~>1.0.0"
end

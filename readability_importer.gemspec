$:.push File.expand_path("../lib", __FILE__)
require "readability_importer/version"

Gem::Specification.new do |s|
  s.name        = "readability_importer"
  s.version     = ReadabilityImporter::VERSION
  s.authors     = ["Yoshimasa Niwa"]
  s.email       = ["niw@niw.at"]
  s.homepage    = "https://github.com/niw/readability_importer"
  s.summary     =
  s.description = "Import many URLs to Readability."

  s.test_files       = `git ls-files -- test/*`.split("\n")
  s.extra_rdoc_files = `git ls-files -- README*`.split("\n")
  s.files            = `git ls-files -- {bin,lib}/*`.split("\n") +
                       s.test_files +
                       s.extra_rdoc_files

  s.require_path = "lib"
  s.bindir       = "bin"
  s.executables  = `git ls-files -- bin/*`.split("\n").map{|path| File.basename(path)}

  s.add_runtime_dependency("eventmachine", "1.0.0.beta.4")
  s.add_runtime_dependency("thor")

  s.add_development_dependency("bundler")
  s.add_development_dependency("rake")
end

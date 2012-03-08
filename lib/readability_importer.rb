require 'readability_importer/version'
require 'readability_importer/event_machine_patch'

module ReadabilityImporter
  autoload :Importer, "readability_importer/importer"
  autoload :Loader, "readability_importer/loader"
  autoload :Command, "readability_importer/command"
end

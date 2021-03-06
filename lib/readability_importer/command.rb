require "thor"

module ReadabilityImporter
  class Command < Thor
    method_option(:email_address, {
      :type => :string,
      :aliases => "-e",
      :required => true,
      :desc => "Readability email address, like 'name-abc@inbox.readability.com'."
    })
    method_option(:from, {
      :type => :string,
      :aliases => "-f",
      :desc => "Your email address."
    })
    method_option(:concurrency, {
      :type => :numeric,
      :aliases => "-c",
      :desc => "Number of concurrency in parallel."
    })
    method_option(:retry, {
      :type => :boolean,
      :aliases => "-r",
      :desc => "Retry when failed."
    })
    method_option(:verbose, {
      :type => :boolean,
      :aliases => "-v",
      :desc => "Verbose mode"
    })
    Loader.loaders.each do |(name, klass)|
      method_option(name, {
        :type => klass.type,
        :desc => klass.desc
      })
    end
    desc "import", "Import URL to Redability."
    def import
      importer = Importer.new(options[:email_address], {
        :verbose => options[:verbose],
        :from => options[:from],
        :max_concurrency => options[:concurrency],
        :retry => options[:retry],

        :on_importing => proc do |urls|
          puts "Importing #{urls.size} url(s)..."
        end,
        :on_imported => proc do |urls|
          puts urls.map{|u| "Imported #{u}"}
        end,
        :on_failed => proc do |urls|
          puts urls.map{|u| "Failed #{u}"}
        end
      })
      Loader.loaders.each do |(name, klass)|
        if options[name]
          loader = klass.new(options[name])
          urls = loader.load
          puts "Start importing #{urls.size} url(s)."
          importer.import(urls)
        end
      end
    end

    desc "version", "Print the version"
    def version
      puts VERSION
    end
  end
end

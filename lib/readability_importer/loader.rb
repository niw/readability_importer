require 'csv'

module ReadabilityImporter
  module Loader
    def self.loaders
      @loaders ||= constants.inject({}) do |loaders, klass_name|
        if /Loader$/ === klass_name
          klass = const_get(klass_name)
          name = klass_name.to_s.tap do |s|
            s.gsub!(/Loader$/, '')
            s.gsub!(/([A-Z+])([A-Z][a-z])/, '\1_\2')
            s.gsub!(/([a-z\d])([A-Z])/, '\1_\2')
            s.tr!("-", "_")
            s.downcase!
          end.to_sym
          loaders[name] = klass
        end
        loaders
      end
    end

    class Base
      def self.desc
      end

      def self.type
        :string
      end
    end

    class UrlsLoader < Base
      def self.desc
        "List of URLs."
      end

      def self.type
        :array
      end

      def initialize(urls)
        @urls = urls
      end

      def load
        if @urls.empty?
          STDIN.read.split(/\s+/)
        else
          @urls
        end
      end
    end

    class InstapaperCsvLoader < Base
      def self.desc
        "Path to CSV file"
      end

      def initialize(path)
        @path = path
      end

      def load
        CSV.read(@path).map do |line|
          line[0]
        end.reverse
      end
    end
  end
end

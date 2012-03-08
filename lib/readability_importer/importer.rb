require 'eventmachine'
require 'resolv'

module ReadabilityImporter
  class Importer
    MAX_URLS_IN_MAIL = 20.freeze

    def initialize(email_address, options = {})
      @email_address = email_address

      @from = options[:from] || "foo@bar"
      @max_concurrency = options[:max_concurrency] || 4
      @verbose = !!options[:verbose]
      @retry = !!options[:retry]

      @on_importing = options[:on_importing]
      @on_imported = options[:on_imported]
      @on_failed = options[:on_failed]
    end

    def import(urls)
      urls_set = []
      urls.each_slice(MAX_URLS_IN_MAIL){|urls| urls_set << urls}

      EventMachine.run do
        iterator = EventMachine::Iterator.new(urls_set, @max_concurrency)
        iterator.each(proc do |urls, it|
          @on_importing.call(urls) if @on_importing
          EventMachine::Protocols::SmtpClient.send({
            :verbose => @verbose,
            :domain => domain,
            :host   => host,
            :from   => @from,
            :to     => @email_address,
            :header => {"From" => @from, "To" => @email_address},
            :body   => urls.join("\r\n")
          }).tap do |job|
            job.callback do
              @on_imported.call(urls) if @on_imported
              it.next
            end
            job.errback do |*args|
              @on_failed.call(urls) if @on_failed
              if @retry
                iterator.instance_variable_get(:@list).unshift(urls)
              end
              it.next
            end
          end
        end, proc do
          EventMachine.stop
        end)
      end
    end

    private

    def domain
      @domain ||= $1 if /@([^@]+)$/ === @email_address
    end

    def host
      @host ||= begin
        resource = Resolv::DNS.new.getresource(domain, Resolv::DNS::Resource::IN::MX)
        if Resolv::DNS::Resource::IN::MX === resource
          resource.exchange.to_s
        end
      end
    end
  end
end

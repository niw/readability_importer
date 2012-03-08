require 'eventmachine'

# Patch EventMachine::Protocol::SmtpClient to use HELO instead.
# Readability SMTP server doesn't understand EHLO.
# See lib/em/protocols/smtpclient.rb
module EventMachine
  module Protocols
    class SmtpClient
      def receive_signon
        return invoke_error unless @range == 2
        send_data "HELO #{@args[:domain]}\r\n"
        @responder = :receive_ehlo_response
      end
    end
  end
end

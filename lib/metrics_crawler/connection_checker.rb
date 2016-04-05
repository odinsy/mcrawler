require 'socket'
require 'timeout'

module MetricsCrawler
  module ConnectionChecker
    def port_open?(ip, port, seconds = 2)
      Timeout::timeout(seconds) do
        begin
          TCPSocket.new(ip, port).close
          true
        rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
          false
        end
      end
    rescue Timeout::Error
      false
    end
  end
end

require_relative('titania.rb')

module Titania::System::Core
# Server class, used for listening incoming http connection
  class HttpServer
    # Initialize a new instance of Server
    # @param [ResourcesProvider] provider : The resource provider to provide the client with resources
    def initialize(provider=nil)
      @logs = Array.new()
      @resourceProvider = provider;
    end

    # Start the server
    # @param [int] port : The port to bind the server
    # @param [function] onClient : Callback called when a client is requesting, (client:HttpClient)
    def start(port, &onClient)
      require('socket.rb')
      require('syck/stringio.rb')

      # Loop the server forever
      Socket.tcp_server_loop(port) { |client, clientAddr|
        # Use new thread to prevent blocking, so we can manage multiple clients
        Thread.new {
          begin
            headers = Array.new()
            while true
              line = client.readline()
              # End of http header is an empty line
              if (line.chop() == "")
                break
              end
              headers.push(line.chop)
            end
            # Used to validate the http request format
            rxHttpRequest = /(GET|POST|get|post) (.+) (HTTP\/[0-9]\.[0-9])/
            httpRequest = headers.first()
            # Remove http request header
            headers.delete_at(0)

            isProperHeader = rxHttpRequest.match(httpRequest)

            unless isProperHeader
              @logs.push("[HTTP.ERROR] HTTP header not in correct format (#{clientAddr.ip_address}:#{clientAddr.ip_port})")
            else
              @logs.push("[HTTP.REQUEST] #{httpRequest} (#{clientAddr.ip_address}:#{clientAddr.ip_port})")

              url = isProperHeader[2].to_s
              httpClient = HttpClient.new(client, headers, url)
              if @resourceProvider
                # If the resources provider cant handle the client
                unless @resourceProvider.handleClient(httpClient)
                  # Let the user handle it
                  onClient.call(httpClient)
                end
              else
                # If no resources provider specified, let the user handle it
                onClient.call(httpClient)
              end
            end
          ensure
            # Exiting block does not close the client
            client.close()
          end
        }
      }
    end
  end
end
require_relative('titania.rb')
module Titania::System::Core
# Route an http request into specific action
  class HttpRouter
    # Initialize a new instance of HttpRouter
    def initialize
      @httpServer = HttpServer.new()
      @httpAction = Hash.new()
      # Default action for undefined path
      @undefinedPath = lambda { |client|
        client.writeHead(404, {'Content-type' => 'text/html'})
        client.write('Page not found')
        client.end()
      }
    end

    # Define a block that manage a path
    # @param [string] path : The url to assign the action to
    # @param [function] block : Callback called when the specified path is accessed by client
    def path(path, &block)
      @httpAction[path] = block
    end

    # Set action to execute when an action for a path is not exists
    # @param [function] block : Callback called when the router route an undefined path (client)
    def undefinedPath=(&block)
      @undefinedPath = block
    end

    # Run a http server on a port with this router to manage its routing
    # @param [int] port : Port to bind this router server to
    def start(port)
      @httpServer.start(port) { |client|
        # If the path have a manager
        if @httpAction[client.url]
          @httpAction[client.url].call(client)
        else
          @undefinedPath.call(client)
        end
      }
    end
  end

end
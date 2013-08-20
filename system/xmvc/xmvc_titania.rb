require_relative('../core/titania.rb')
require_relative('xmvc_adapter.rb')
require_relative('xmvc_controller.rb')
require_relative('xmvc_generator.rb')
require_relative('xmvc_helper.rb')
require_relative('xmvc_model.rb')
require_relative('xmvc_view.rb')

module Titania::System::XMVC
# Web server for XMVC mode of Titania
# It does not uses the native router from Titania, since it have to manages its own url format
# It manages its own routing to the /framework/xmvc folder
  class XMVCTitania
    # Initialize a new instance of XMVCTitania
    # @param [ResourcesProvider] provider : The resource provider used to manage resource
    def initialize(provider=nil)

      @httpServer = Titania::System::Core::HttpServer.new(provider)
      @resources = Hash.new()
      @provider = provider
    end

    # Start the XMVC web server
    # @param [int] port : Port number to bind to this server, if not specified. It will pick the first argument from
    # command line arguments
    def start(port=nil)
      if port == nil
        port = $*.first()
      end
      @httpServer.start(port) { |client|

        # Remove the first slash and split the url by slash
        urls = client.url[1..-1].split('/')

        # Extract url data and defaults (the default should be configurable?)
        # Remember that its case-sensitive
        packageName = urls[0] || 'index'
        controllerName = urls[1] || 'Index'
        methodName = urls[2] || 'index'
        # The remaining url data were the arguments
        args = urls[3..-1]

        begin
          # Remember that the filename is all lowercase, while class name are WordCase
          unless File.exists?("#{$root}framework/xmvc/controllers/#{packageName.downcase()}/#{controllerName.downcase()}.rb")
            # This should be configurable?
            client.writeHead(404, {'Content-type' => 'text/html'})
            client.write('Not Found')
            client.end()
          else
            # Require controller definition (all file/folder must be in lowercase)
            require("#{$root}framework/xmvc/controllers/#{packageName.downcase()}/#{controllerName.downcase()}.rb")
            # Titania url is case sensitive
            ctrl = eval("#{controllerName}.new()")
            method = ctrl.method(methodName)
            method.call(client, args)
          end
        ensure
          puts $!
        end
      }
    end
  end
end

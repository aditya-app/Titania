require_relative('../core/titania.rb')
require_relative('xmvc_titania.rb')

module Titania::System::XMVC
# The base class for all controller of XMVCTitania
  class XMVCController

    def initialize
      @view = XMVCView.new()
    end

    # Default method called when the client does not supply method name in the url
    # @param [HttpClient] client : The client
    # @param [array] args : Additional url parameter passed
    def index(client, args=nil)

    end

  end
end

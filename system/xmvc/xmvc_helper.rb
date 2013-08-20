require_relative('../core/titania.rb')
require_relative('xmvc_titania.rb')

module Titania::System::XMVC
  # Helper for XMVC Controller
  class XMVCHelper
    # Initialize a new instance of XMVCHelper
    # @param [XMVCController] controller : The controller responsible for using this helper
    def initialize(controller=nil)
      @controller = controller
    end
  end
end
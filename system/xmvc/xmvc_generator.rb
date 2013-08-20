require_relative('../core/titania.rb')
require_relative('xmvc_titania.rb')

module Titania::System::XMVC
  # Responsible for generating formatted data
  class XMVCGenerator
    # Initialize a new instance of XMVCGenerator
    # @param [XMVCController] controller : The controller responsible for calling this generator
    def initialize(controller=nil)
      @controller = nil
    end
  end
end
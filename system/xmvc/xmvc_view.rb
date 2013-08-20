require_relative('../core/titania.rb')
require_relative('xmvc_titania.rb')

module Titania::System::XMVC
  # Manage view processing
  # View is rendered as an html, it only capable of evaluating a single line
  # Processing structure of view should be done using generator
  class XMVCView
    # Load a view, process it and return its output
    # @param [string] viewName : The name of the view
    # @param [hash] data : The data to pass to the view
    def load(viewName, data=nil)
      file = File.new("#{$root}framework/xmvc/views/#{viewName}")
      lines = file.readlines().join("\r\n")
      rxTitaniaEmbedded = /<%(.+)%>/i

      # Iterate through all embedded syntax
      while true
        m = rxTitaniaEmbedded.match(lines)
        # If no more embedded syntax
        unless m
          break
        end
        # Extract the embedded syntax, evaluate it, and put it on line buffer
        embeddedRuby = m[1]
        actualText = m[0]
        evaluatedValue = eval(embeddedRuby)
        lines.gsub!(actualText, evaluatedValue.to_s)
      end
      return lines
    end
  end
end
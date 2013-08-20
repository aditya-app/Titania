require_relative('titania.rb')
module Titania::System::Core
# Used to load configuration file
# Configuration are actually hash defined in ruby syntax
  class ConfigurationLoader
    # Load the configuration file
    # Use $root for referencing the root folder of Titania framework
    # @param [string] path : Path to the configuration file
    def ConfigurationLoader.load(path)
      # Open the file, read it and evaluate its content
      configFile = File.new(path)
      lines = configFile.readlines()
      content = lines.join("\r\n")
      return eval(content)
    end
  end
end
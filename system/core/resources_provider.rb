require_relative('titania.rb')

module Titania::System::Core
# Provide resources access (images, scripts, styles, etc)
  class ResourcesProvider
    def initialize
      @configurations = ConfigurationLoader.load("#{$root}system/configurations/resources_provider.conf")
      @resources = Hash.new()
    end

    # Load files in a folder (does not include sub-directory) as a resources
    # Only file with extension defined in /system/core/configurations/resources_provider.conf only will be loaded
    # Use $root to provide the resourceFolder parameter
    # @param [string] resourceFolder : Path to the folder contain the resources
    # @param [string] provideIn : Location or url base for the client can access the resource
    def provide(resourceFolder, provideIn)
      dir = Dir.new(resourceFolder)
      # Get files in folder, check whether the server support them
      while entry = dir.read()
        if File.file?("#{resourceFolder}/#{entry}")
          ext = File.extname(entry)
          if @configurations['supported_type'].has_key?(ext)
            # Add to resources dictionary
            @resources["#{provideIn}/#{entry}"] = "#{resourceFolder}/#{entry}"
          end
        end
      end
    end

    # Handle a client
    # @param [HttpClient] client : The client to handle
    # @return [bool] : True if the client is handled, false otherwise
    def handleClient(client)
      # If the requested url is an resource
      if @resources.has_key?(client.url)
        ext = File.extname(client.url)
        # Send the resource file
        client.writeHead(200, {
            'Content-type' => @configurations["supported_type"][ext],
            'Connection' => @configurations["connection_mode"],
            'Content-length' => File.size(@resources[client.url]),
        }, true)
        client.writeFile(@resources[client.url])
        client.end()
        # Handled
        return true
      end
      # The client is not handled
      return false
    end
  end
end
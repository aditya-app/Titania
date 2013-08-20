require_relative('titania.rb')

module Titania::System::Core
# Encapsulate the native http client
  class HttpClient

    private_instance_methods :formatHeader

    # Initialize a new instance of http client
    # @param [stream] client : The native http client
    # @param [array] headers : Headers sent by the client
    # @param [string] url : The url requested by the client
    def initialize(client, headers, url)
      @client = client

      @headers = Hash.new()
      formatHeader(headers)

      @url = url
      # Used to track whether the respone header has been sent or not
      @headerSent = false
      @@httpCodes = {
          200 => "Ok",
          404 => "Page Not Found",
          503 => "Internal Server Error"
      }
    end

    # Format the header into hash
    # @param [array] headers : Array of header to convert into hash
    def formatHeader(headers)
      headers.each() { |header|
        rxHeader = /^(.+): (.+)$/
        match = rxHeader.match(header)
        if match
          @headers[match[1]] = match[2]
        end
      }
    end

    # Get the url requested by the client
    def url
      return @url
    end

    # Write a header to this client (this must be called before any other output to the client)
    # @param [int] responseCode : The response code of the header
    # @param [hash] headers : Hash collection of headers (default headers will be included if noDefault is set to false)
    # @param [bool] noDefaults : Specify whether default header will be sent
    # Default Headers:
    # Transfer-Encoding: chunked, Connection: keep-alive
    def writeHead(responseCode, headers, noDefaults=false)
      require('syck/stringio.rb')
      unless @headerSent
        IO.copy_stream(StringIO.new("HTTP/1.1 #{responseCode} #{@@httpCodes[responseCode]}\r\n"), @client)

        unless noDefaults
          unless headers['Transfer-encoding']
            headers['Transfer-encoding'] = 'chunked'
            @isChunked=true
          end
          unless headers['Connection']
            headers['Connection'] = 'keep-alive'
          end
        end

        # Output headers to client
        headers.each() { |k, v|
          IO.copy_stream(StringIO.new("#{k}: #{v}\r\n"), @client)
        }
        IO.copy_stream(StringIO.new("\r\n"), @client)

        # Allow any other output
        @headerSent=true
      else
        raise Exception, 'Header already sent'
      end
    end

    # Write a file to the client (file type must be sent via header first)
    # !! THIS IS NOT USED TO INCLUDE A FILE INTO CURRENT OUTPUT !!
    # !! IT IS USED TO SEND A SINGLE FILE TO THE OUTPUT !!
    # !! TO SEND ASCII FILE, LOAD THE FILE CONTENT FIRST AND SEND USING write() METHOD !!
    # Use the $root variable to get the root directory of Titania framework
    # @param [string] fileLocation : Path to the file
    def writeFile(fileLocation)
      if @headerSent
        file = File.new(fileLocation);
        IO.copy_stream(file.to_io, @client);
        @isFile=true
      else
        raise Exception, "Headers hasn't been send"
      end

    end

    # Write a data to the client (must be called after writeHead() method)
    # @param [string] data : The data to send to the client
    def write(data)
      if @headerSent
        IO.copy_stream(StringIO.new("#{data.length.to_s(16)}\r\n"), @client)
        IO.copy_stream(StringIO.new("#{data}\r\n"), @client)
      else
        raise Exception, "Headers hasn't been send"
      end
    end

    # End writing output to the client (should be called after all output were done)
    def end
      # Chunked encoding need this to act indicate the end of stream
      if @isChunked
        IO.copy_stream(StringIO.new("0"), @client)
        IO.copy_stream(StringIO.new("\r\n"), @client)
        IO.copy_stream(StringIO.new("\r\n"), @client)
      end
    end
  end
end

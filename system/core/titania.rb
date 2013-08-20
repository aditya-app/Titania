# Titania is a ruby web framework, (that i hope are) simple, easy to use, and fast
# created by Aditya Purwa

# This file declare the core variables and configurations used by Titania framework (must be required first)

# Store path to the root directory of Titania framework
$root = "#{File.dirname($0)}/"

# Define namespace structure of Titania framework
# The base Titania namespace
module Titania
  # Contains specific system files
  module System
    # Core file needed by Titania
    module Core
    end
    # Core for XMVC support
    module XMVC
    end
  end
end

require_relative('configuration_loader')
require_relative('http_client')
require_relative('http_router')
require_relative('http_server')
require_relative('resources_provider')
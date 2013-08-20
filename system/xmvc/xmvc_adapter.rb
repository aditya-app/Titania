require_relative('../core/titania.rb')
require_relative('xmvc_titania.rb')

module Titania::System::XMVC
  # Responsible for interfacing between model and database
  class XMVCAdapter
    # Initialize a new instance of XMVCAdapter
    # @param [string] databaseName : The name of the database
    # @param [string] username : Username for connecting to the database
    # @param [string] password : Password for connecting to the database
    def initialize(databaseName=nil, username=nil, password=nil)

    end

    def insert(table, data, extras=nil)
    end

    def select(table, filter=nil, joins=nil, extras=nil)
    end

    def update(table, data, filter=nil, extras=nil)
    end

    def delete(table, filter=nil, extras=nil)
    end

  end
end
module Bluetooth

  VERSION = '1.0'

  ERRORS = {}

  class Error < RuntimeError
    def self.raise status
      raise(*ERRORS[status])
    end
  end

  autoload :Device, 'bluetooth/device'

end

require 'bluetooth/bluetooth'


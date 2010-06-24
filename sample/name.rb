require 'bluetooth'

address = ARGV.shift || abort("#{$0} address")

device = Bluetooth::Device.new address

puts device


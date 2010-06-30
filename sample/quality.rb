require 'bluetooth'

address = ARGV.shift || abort("#{$0} address # look up device with scan.rb")

device = Bluetooth::Device.new address

puts "link quality: #{device.link_quality}, RSSI: #{device.rssi}"


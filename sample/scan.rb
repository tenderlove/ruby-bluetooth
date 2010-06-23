require "ruby_bluetooth"

a = Bluetooth::Devices.scan
a.each { |device|
  puts device
}

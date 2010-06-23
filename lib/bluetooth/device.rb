module Bluetooth
  Device = Struct.new :name, :address do

    def to_s
      "#{name} at #{address}"
    end

  end
end

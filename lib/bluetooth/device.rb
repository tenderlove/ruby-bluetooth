class Bluetooth::Device

  attr_accessor :address

  attr_writer :name

  def initialize address, name = nil
    @address = address
    @name = name
  end

  def address_bytes
    @address.split('-').map { |c| c.to_i(16) }.pack 'C*'
  end

  def name
    return @name if @name

    @name = request_name

    return '(unknown)' unless @name

    @name
  end

  def to_s
    "#{name} at #{address}"
  end

end


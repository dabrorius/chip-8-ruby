class Registers
  def initialize
    @registers = []
  end

  def set(position, value)
    fail ArgumentError.new("Position 0x#{position.to_s(16)} is out of range") if position > 0xF || position < 0
    fail ArgumentError.new("Value 0x#{position.to_s(16)} is out of range") if value > 0xFFFF || value < 0x0
    @registers[position] = value
  end

  def get(position)
    fail ArgumentError.new("Position 0x#{position.to_s(16)} is out of range") if position > 0xF || position < 0
    @registers[position]
  end
end
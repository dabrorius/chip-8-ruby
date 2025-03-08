class Registers
  def initialize
    @registers = []
  end

  def set(position, value)
    fail ArgumentError.new("Position 0x#{position.to_s(16)} is out of range") if position > 0xF || position < 0
    @registers[position] = value % 0x100
  end

  def get(position)
    fail ArgumentError.new("Position 0x#{position.to_s(16)} is out of range") if position > 0xF || position < 0
    @registers[position]
  end
end
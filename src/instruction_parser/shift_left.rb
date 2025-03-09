require_relative "../const"

module InstructionParser
  # Format: 8xyE
  # Store most signficant bit of Vx into VF, then shift bits in Vx one place to the left.
  class ShiftLeft
    def initialize(executor)
      @executor = executor
    end

    def match_and_call(command_hex_array)
      if command_hex_array in [8, x, y, 0xE]
        call(x)
        return true
      end
      false
    end

    private

    def call(register_x)
      value_x = @executor.registers.get(register_x)
      @executor.vf_register = value_x / 0b1000_0000
      @executor.registers.set(register_x, (value_x * 2) % 0xFFFF)
      @executor.pc += Const::COMMAND_SIZE
    end
  end
end

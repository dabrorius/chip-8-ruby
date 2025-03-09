require_relative "../const"

module InstructionParser
  # Format: 8xy6
  # Store least signficant bit of Vx into VF, then shift bits in Vx one place to the right.
  class ShiftRight
    def initialize(executor)
      @executor = executor
    end

    def match_and_call(command_hex_array)
      if command_hex_array in [8, x, y, 6]
        call(x)
        return true
      end
      false
    end

    private

    def call(register_x)
      value_x = @executor.registers.get(register_x)
      @executor.vf_register = value_x % 0b10
      @executor.registers.set(register_x, value_x / 2)
      @executor.pc += Const::COMMAND_SIZE
    end
  end
end

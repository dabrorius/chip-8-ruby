require_relative "../const"

module InstructionParser
  # Format: 8xy7
  # Calculates Vy - Vx and stores result in Vx
  # Sets Vf to 1 if Vy > Vx, to 0 otherwise
  class SubtractRegisterReverse
    def initialize(executor)
      @executor = executor
    end

    def match_and_call(command_hex_array)
      if command_hex_array in [8, x, y, 7]
        call(x, y)
        return true
      end
      false
    end

    private

    def call(register_x, register_y)
      value_x = @executor.registers.get(register_x)
      value_y = @executor.registers.get(register_y)
      @executor.vf_register = value_y > value_x ? 1 : 0
      @executor.registers.set(register_x, value_y - value_x)
      @executor.pc += Const::COMMAND_SIZE
    end
  end
end

require_relative "../const"

module InstructionParser
  # Format: 8xy5
  # Subtract value from register Vy to register Vx
  class SubtractRegister
    def initialize(executor)
      @executor = executor
    end

    def match_and_call(command_hex_array)
      if command_hex_array in [8, x, y, 5]
        call(x, y)
        return true
      end
      false
    end

    private

    def call(register_x, register_y)
      value_x = @executor.registers.get(register_x)
      value_y = @executor.registers.get(register_y)
      @executor.vf_register = value_x > value_y ? 1 : 0
      @executor.registers.set(register_x, value_x - value_y)
      @executor.pc += Const::COMMAND_SIZE
    end
  end
end

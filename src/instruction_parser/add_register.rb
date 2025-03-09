require_relative "../const"

module InstructionParser
  # Format: 8xy4
  # Adds value from register Vy to register Vx
  class AddRegister
    def initialize(executor)
      @executor = executor
    end

    def match_and_call(command_hex_array)
      if command_hex_array in [8, x, y, 4]
        call(x, y)
        return true
      end
      false
    end

    private

    def call(register_x, register_y)
      value_x = @executor.registers.get(register_x)
      value_y = @executor.registers.get(register_y)
      raw_result = value_x + value_y
      @executor.vf_register = raw_result / 0x100
      @executor.registers.set(register_x, raw_result)
      @executor.pc += Const::COMMAND_SIZE
    end
  end
end

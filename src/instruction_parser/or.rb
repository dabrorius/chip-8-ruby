require_relative "../const"

module InstructionParser
  # Format: 8xy1
  # Calculates binary OR between values Vx and Vym then stores it to Vx
  class Or
    def initialize(executor)
      @executor = executor
    end

    def match_and_call(command_hex_array)
      if command_hex_array in [8, x, y, 1]
        call(x, y)
        return true
      end
      false
    end

    private

    def call(register_x, register_y)
      value_x = @executor.registers.get(register_x)
      value_y = @executor.registers.get(register_y)
      @executor.registers.set(register_x, value_x | value_y)
      @executor.pc += Const::COMMAND_SIZE
    end
  end
end

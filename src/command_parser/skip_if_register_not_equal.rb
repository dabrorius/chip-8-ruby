require_relative "../const"

module CommandParser
  # Format: 9xy0
  # Skips next command if register Vx is not equal to register Vy
  class SkipIfRegisterNotEqual
    def initialize(executor)
      @executor = executor
    end

    def match_and_call(command_hex_array)
      if command_hex_array in [9, x, y, 0]
        call(x, y)
        return true
      end
      false
    end

    private

    def call(register_x, register_y)
      register_x_value = @executor.registers.get(register_x)
      register_y_value = @executor.registers.get(register_y)
      @executor.pc += Const::COMMAND_SIZE if register_x_value != register_y_value
      @executor.pc += Const::COMMAND_SIZE
    end
  end
end

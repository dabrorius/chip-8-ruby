require_relative "../const"

module CommandParser
  # Format: 4xnn
  # Skips next command if register Vx is not equal to literal vlaue NN
  class SkipIfLiteralNotEqual
    def initialize(executor)
      @executor = executor
    end

    def match_and_call(command_hex_array)
      if command_hex_array in [4, x, n1, n2]
        call(x, n1 * 0x10 + n2)
        true
      end
      false
    end

    private

    def call(position, value)
      register_value = @executor.registers.get(position)
      @executor.pc += Const::COMMAND_SIZE if register_value != value
      @executor.pc += Const::COMMAND_SIZE
    end
  end
end

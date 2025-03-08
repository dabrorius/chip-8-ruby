require_relative "../const"

module CommandParser
  # Format: 3xnn
  # Skips next command if register Vx is equal to literal value NN
  class SkipIfLiteralEqual
    def initialize(executor)
      @executor = executor
    end

    def match_and_call(command_hex_array)
      if command_hex_array in [3, x, n1, n2]
        call(x, n1 * 0x10 + n2)
        true
      end
      false
    end

    private

    def call(register, value)
      register_value = @executor.registers.get(register)
      @executor.pc += Const::COMMAND_SIZE if register_value == value
      @executor.pc += Const::COMMAND_SIZE
    end
  end
end

require_relative "../const"

module InstructionParser
  # Format: 6xnn
  # Loads value NN to register Vx
  class LoadLiteral
    def initialize(executor)
      @executor = executor
    end

    def match_and_call(command_hex_array)
      if command_hex_array in [6, x, n1, n2]
        call(x, n1 * 0x10 + n2)
        return true
      end
      false
    end

    private

    def call(register, value)
      @executor.registers.set(register, value)
      @executor.pc += Const::COMMAND_SIZE
    end
  end
end

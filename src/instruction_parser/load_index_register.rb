require_relative "../const"

module InstructionParser
  # Format: Annn
  # Loads index register with value NNN
  class LoadIndexRegister
    def initialize(executor)
      @executor = executor
    end

    def match_and_call(command_hex_array)
      if command_hex_array in [0xA, n1, n2, n3]
        call(n1 * 0x100 + n2 * 0x10 + n3)
        return true
      end
      false
    end

    private

    def call(value)
      @executor.index_register = value
      @executor.pc += Const::COMMAND_SIZE
    end
  end
end

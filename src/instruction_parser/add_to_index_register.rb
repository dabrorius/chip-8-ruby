require_relative "../const"

module InstructionParser
  # Format: Fx1E
  # Adds value from register Vx to index register
  class AddToIndexRegister
    def initialize(executor)
      @executor = executor
    end

    def match_and_call(command_hex_array)
      if command_hex_array in [0xF, x, 1, 0xE]
        call(x)
        return true
      end
      false
    end

    private

    def call(register)
      register_value = @executor.registers.get(register)
      @executor.index_register = (@executor.index_register + register_value) % 0x10000
      @executor.pc += Const::COMMAND_SIZE
    end
  end
end

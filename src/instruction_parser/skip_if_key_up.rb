require_relative "../const"

module InstructionParser
  # Format: ExA1
  # Skips next command unless key equal to register Vx is held down
  class SkipIfKeyUp
    def initialize(executor)
      @executor = executor
    end

    def match_and_call(command_hex_array)
      if command_hex_array in [0xE, x, 0xA, 1]
        call(x)
        return true
      end
      false
    end

    private

    def call(register)
      register_value = @executor.registers.get(register)
      @executor.pc += Const::COMMAND_SIZE unless @executor.keys_down.include?(register_value)
      @executor.pc += Const::COMMAND_SIZE
    end
  end
end

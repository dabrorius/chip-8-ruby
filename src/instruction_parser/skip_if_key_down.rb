require_relative "../const"

module InstructionParser
  # Format: Ex9E
  # Skips next command if key equal to register Vx is held down
  class SkipIfKeyDown
    def initialize(executor)
      @executor = executor
    end

    def match_and_call(command_hex_array)
      if command_hex_array in [0xE, x, 9, 0xE]
        call(x)
        return true
      end
      false
    end

    private

    def call(register)
      register_value = @executor.registers.get(register)
      @executor.pc += Const::COMMAND_SIZE if @executor.keys_down.include?(register_value)
      @executor.pc += Const::COMMAND_SIZE
    end
  end
end

require_relative "../const"

module InstructionParser
  # Format: Fx15
  # Loads value from register Vx into delay register
  class SetDelayTimer
    def initialize(executor)
      @executor = executor
    end

    def match_and_call(command_hex_array)
      if command_hex_array in [0xF, x, 1, 5]
        call(x)
        return true
      end
      false
    end

    private

    def call(register)
      value = @executor.registers.get(register)
      @executor.delay_register = value
      @executor.pc += Const::COMMAND_SIZE
    end
  end
end

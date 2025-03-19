require_relative "../const"

module InstructionParser
  # Format: Fx07
  # Loads Vx with the value of the delay timer
  class LoadDelayTimer
    def initialize(executor)
      @executor = executor
    end

    def match_and_call(command_hex_array)
      if command_hex_array in [0xF, x, 0, 7]
        call(x)
        return true
      end
      false
    end

    private

    def call(register)
      value = @executor.delay_register
      @executor.registers.set(register, value)
      @executor.pc += Const::COMMAND_SIZE
    end
  end
end

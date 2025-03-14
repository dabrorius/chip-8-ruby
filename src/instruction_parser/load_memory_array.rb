require_relative "../const"

module InstructionParser
  # Format: Fx65
  # Loads registers V0 to Vx with values from memory starting at
  # location stored at I register.
  class LoadMemoryArray
    def initialize(executor)
      @executor = executor
    end

    def match_and_call(command_hex_array)
      if command_hex_array in [0xF, x, 6, 5]
        call(x)
        return true
      end
      false
    end

    private

    def call(last_register)
     (0..last_register).each do |n|
        memory_position = @executor.index_register + n
        integer_value_at_position = @executor.memory[memory_position].ord
        @executor.registers.set(n, integer_value_at_position)
      end
      @executor.pc += Const::COMMAND_SIZE
    end
  end
end

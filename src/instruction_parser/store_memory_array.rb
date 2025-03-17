require_relative "../const"

module InstructionParser
  # Format: Fx55
  # Stores registers V0 to Vx to the memory starting at
  # location stored in I register.
  class StoreMemoryArray
    def initialize(executor)
      @executor = executor
    end

    def match_and_call(command_hex_array)
      if command_hex_array in [0xF, x, 5, 5]
        call(x)
        return true
      end
      false
    end

    private

    def call(last_register)
      (0..last_register).each do |n|
        memory_position = @executor.index_register + n
        register_value = @executor.registers.get(n)
        value_as_padded_string = register_value.to_s(16).rjust(2, "0")
        @executor.memory[memory_position] = [value_as_padded_string].pack("H*")
      end
      @executor.pc += Const::COMMAND_SIZE
    end
  end
end

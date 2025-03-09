require_relative "../const"

module InstructionParser
  # Format: 2nnn
  # Pushes current PC to stack_pointer and moves PC to value NNN
  class Call
    def initialize(executor)
      @executor = executor
    end

    def match_and_call(command_hex_array)
      if command_hex_array in [2, n1, n2, n3]
        call(n1 * 0x100 + n2 * 0x10 + n3)
        return true
      end
      false
    end

    private

    def call(value)
      @executor.stack_pointer.push(@executor.pc)
      @executor.pc = value
    end
  end
end

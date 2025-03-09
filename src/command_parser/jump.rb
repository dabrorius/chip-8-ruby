require_relative "../const"

module CommandParser
  # Format: 1nnn
  # Moves PC to value NNN
  class Jump
    def initialize(executor)
      @executor = executor
    end

    def match_and_call(command_hex_array)
      if command_hex_array in [1, n1, n2, n3]
        call(n1 * 0x100 + n2 * 0x10 + n3)
        return true
      end
      false
    end

    private

    def call(value)
      @executor.pc = value
    end
  end
end

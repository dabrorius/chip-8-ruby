require_relative "../const"

module CommandParser
  # Format: 00E0
  # Clears the display
  class ClearDisplay
    def initialize(executor)
      @executor = executor
    end

    def match_and_call(command_hex_array)
      if command_hex_array in [0, 0, 0xE, 0]
        call
        true
      end
      false
    end

    private

    def call
      @executor.display.clear
      @executor.pc += Const::COMMAND_SIZE
    end
  end
end

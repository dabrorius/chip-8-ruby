require_relative "../const"

module InstructionParser
  # Format: 00EE
  # Returns from a procedure call
  class Return
    def initialize(executor)
      @executor = executor
    end

    def match_and_call(command_hex_array)
      if command_hex_array in [0, 0, 0xE, 0xE]
        call
        return true
      end
      false
    end

    private

    def call
      if @executor.stack_pointer.any?
        @executor.pc = @executor.stack_pointer.pop + Const::COMMAND_SIZE
      else
        @executor.pc = nil
      end
    end
  end
end

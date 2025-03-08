require_relative "../consts"

# Expects following instance variables:
#
# @pc - program counter
# @stack_pointer - Array of memory positions
#
module Commands
  module Navigation
    def execute_jp(position)
      @pc = position
    end

    def execute_call(position)
      @stack_pointer.push(@pc)
      @pc = position
    end

    def execute_ret
      # For now set PC to nil to indicate end of program
      if @stack_pointer.any?
        @pc = @stack_pointer.pop + Consts::COMMAND_SIZE
      else
        @pc = nil
      end
    end
  end
end
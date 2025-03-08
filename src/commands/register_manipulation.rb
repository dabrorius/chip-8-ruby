require_relative "../const"

# Expects following instance variables:
#
# @pc - program counter
# @registers - Instance of Registers class
#
module Commands
  module RegisterManipulation
    def execute_add(position, value)
      current_value = @registers.get(position)
      @registers.set(position, current_value + value)
      @pc += Const::COMMAND_SIZE
    end
  end
end
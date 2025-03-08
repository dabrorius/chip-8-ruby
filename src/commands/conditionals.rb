require_relative "../const"

# Expects following instance variables:
#
# @pc - program counter
# @registers - Instance of Registers class
#
module Commands
  module Conditionals
    def execute_se(position, value)
      register_value = @registers.get(position)
      @pc += Const::COMMAND_SIZE if register_value == value
      @pc += Const::COMMAND_SIZE
    end

    def execute_sne(position, value)
      register_value = @registers.get(position)
      @pc += Const::COMMAND_SIZE if register_value != value
      @pc += Const::COMMAND_SIZE
    end

    def execute_sre(position1, position2)
      register_value = @registers.get(position1)
      second_register_value = @registers.get(position2)
      @pc += Const::COMMAND_SIZE if register_value == second_register_value
      @pc += Const::COMMAND_SIZE
    end
  end
end
require_relative "../const"

# Expects following instance variables:
#
# @pc - program counter
# @registers - Instance of Registers class
# @vf_register
# @index_register
#
module Commands
  module RegisterManipulation
    def execute_ldi(last_register)
      (0..last_register).each do |n|
        memory_position = @index_register + n
        integer_value_at_position = @memory[memory_position].ord
        @registers.set(n, integer_value_at_position)
      end
      @pc += Const::COMMAND_SIZE
    end

    def execute_wdi(last_register)
      (0..last_register).each do |n|
        memory_position = @index_register + n
        register_value = @registers.get(n)
        value_as_padded_string = register_value.to_s(16).rjust(2, "0")
        @memory[memory_position] = [value_as_padded_string].pack("H*")
      end
      @pc += Const::COMMAND_SIZE
    end
  end
end
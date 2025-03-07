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
    def execute_add(position, value)
      current_value = @registers.get(position)
      @registers.set(position, current_value + value)
      @pc += Const::COMMAND_SIZE
    end

    def execute_ld(position, value)
      @registers.set(position, value)
      @pc += Const::COMMAND_SIZE
    end

    def execute_ldr(register_x, register_y)
      value_y = @registers.get(register_y)
      @registers.set(register_x, value_y)
      @pc += Const::COMMAND_SIZE
    end

    def execute_or(register_x, register_y)
      value_x = @registers.get(register_x)
      value_y = @registers.get(register_y)
      @registers.set(register_x, value_x | value_y)
      @pc += Const::COMMAND_SIZE
    end

    def execute_and(register_x, register_y)
      value_x = @registers.get(register_x)
      value_y = @registers.get(register_y)
      @registers.set(register_x, value_x & value_y)
      @pc += Const::COMMAND_SIZE
    end

    def execute_xor(register_x, register_y)
      value_x = @registers.get(register_x)
      value_y = @registers.get(register_y)
      @registers.set(register_x, value_x ^ value_y)
      @pc += Const::COMMAND_SIZE
    end

    def execute_radd(register_x, register_y)
      value_x = @registers.get(register_x)
      value_y = @registers.get(register_y)
      raw_result = value_x + value_y
      @vf_register = raw_result / 0x100
      @registers.set(register_x, raw_result)
      @pc += Const::COMMAND_SIZE
    end

    def execute_rsub(register_x, register_y)
      value_x = @registers.get(register_x)
      value_y = @registers.get(register_y)
      @vf_register = value_x > value_y
      @registers.set(register_x, value_x - value_y)
      @pc += Const::COMMAND_SIZE
    end

    def execute_shr(register_x)
      value_x = @registers.get(register_x)
      @vf_register = value_x % 2
      @registers.set(register_x, value_x / 2)
      @pc += Const::COMMAND_SIZE
    end

    def execute_rsubn(register_x, register_y)
      value_x = @registers.get(register_x)
      value_y = @registers.get(register_y)
      @vf_register = value_y > value_x
      @registers.set(register_x, value_y - value_x)
      @pc += Const::COMMAND_SIZE
    end

    def execute_shl(register_x)
      value_x = @registers.get(register_x)
      @vf_register = value_x * 2 > 0xFFFF
      @registers.set(register_x, (value_x * 2) % 0xFFFF)
      @pc += Const::COMMAND_SIZE
    end

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

    def execute_bcd(register_x)
      register_value = @registers.get(register_x)

      hundreds = register_value / 100
      tens = (register_value / 10) % 10
      ones = register_value % 10

      puts "GOT #{register_value} => #{hundreds} #{tens} #{ones}"

      @memory[@index_register] = ["0#{hundreds.to_s(16)}"].pack("H*")
      @memory[@index_register + 1] = ["0#{tens.to_s(16)}"].pack("H*")
      @memory[@index_register + 2] = ["0#{ones.to_s(16)}"].pack("H*")

      @pc += Const::COMMAND_SIZE
    end

    def execute_iadd(register_x)
      value_x = @registers.get(register_x)
      @index_register = (@index_register + value_x) % 0x10000

      @pc += Const::COMMAND_SIZE
    end
  end
end
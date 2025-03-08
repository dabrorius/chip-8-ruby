require_relative "../const"

# Expects following instance variables:
#
# @pc - program counter
# @registers - Instance of Registers class
# @vf_register
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
  end
end
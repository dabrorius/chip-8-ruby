require_relative "../const"

module CommandParser
  # Format: Dxyn
  # Draws sprite at location Vx, Vy with content from memory starting at I
  class Draw
    def initialize(executor)
      @executor = executor
    end

    def match_and_call(command_hex_array)
      if command_hex_array in [0xD, x, y, n]
        call(x, y, n)
        return true
      end
      false
    end

    private

    def call(register_x, register_y, n)
      index_register = @executor.index_register
      memory = @executor.memory
      display = @executor.display

      sprite_content = memory[index_register..(index_register + n - 1)]
      x = @executor.registers.get(register_x)
      y = @executor.registers.get(register_y)
      is_any_erased = 0
      sprite_content.bytes.each_with_index do |sprite_row, row_index|
        sprite_row.to_s(2).rjust(8, '0').split("").each_with_index do |sprite_pixel, column_index|
          if sprite_pixel == '1'
            is_erased = display.toggle_pixel(x + column_index, y + row_index)
            is_any_erased = is_any_erased | is_erased
          end
        end
      end
      @executor.vf_register = is_any_erased
      @executor.pc += Const::COMMAND_SIZE
    end
  end
end

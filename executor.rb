require_relative "./registers"
require_relative "./display"

LOAD_PROGRAM_ADDRESS = 0x200
COMMAND_SIZE = 2

class Executor
  def initialize
    @registers = Registers.new
    @memory = "".b
    @pc = LOAD_PROGRAM_ADDRESS
    @display = Display.new
    @index_register = 0
  end

  def load_program(code)
    @memory = @memory.ljust(LOAD_PROGRAM_ADDRESS)[..LOAD_PROGRAM_ADDRESS]
    @memory += code
  end

  def step
    execute_current_command
  end

  def can_step?
    !@pc.nil?
  end

  def execute_program
    # We set PC to nil when we want to exit program
    while !@pc.nil?
      execute_current_command
      render
    end
  end

  def inspect_registers
    (0..0xF).map do |index|
      @registers.get(index)
    end
  end

  def inspect_index_register
    @index_register
  end

  def get_display_pixel(column, row)
    @display.get_pixel(column, row)
  end

  private

  def execute_current_command
    command_hex_array = current_command.unpack("H*").first.chars.map { |digit| digit.to_i(16) }

    case command_hex_array
    in [0, 0, 0xE, 0] # 00E0 | CLS | clears the display
      execute_cls
      next_command
    in [1, n1, n2, n3] # 1NNN | JP | jump to location NNN
      execute_jp(n1 * 0x100 + n2 * 0x10 + n3)
    in [6, x, n1, n2] # 6XNN | LD | loads register X with value NN
      execute_ld(x, n1 * 0x10 + n2)
      next_command
    in [7, x, n1, n2] # 7XNN | ADD | adds value NN to register X
      execute_add(x, n1 * 0x10 + n2)
      next_command
    in [0, 0, 0xE, 0xE] # 00EE | RET | return from subroutine
      execute_ret
    in [0xA, n1, n2, n3] # ANNN | ILD | loads I register with value NNN
      execute_ild(n1 * 0x100 + n2 * 0x10 + n3)
      next_command
    in [0xD, x, y, n] # DXYN | DRW | draws sprite to display
      execute_drw(x, y, n)
      next_command
    else
      fail "Reached unknown command #{command_hex_array}"
    end
  end

  def current_command
    first_part = @memory[@pc..@pc+1]
  end

  def next_command
    @pc += COMMAND_SIZE
  end

  def execute_ld(position, value)
    @registers.set(position, value)
  end

  def execute_add(position, value)
    current_value = @registers.get(position)
    @registers.set(position, current_value + value)
  end

  def execute_jp(position)
    @pc = position
  end

  def execute_ret
    # For now set PC to nil to indicate end of program
    @pc = nil
  end

  def execute_ild(value)
    @index_register = value
  end

  def execute_cls
    @display.clear
  end

  def execute_drw(register_x, register_y, n)
    sprite_content = @memory[@index_register..(@index_register + n - 1)]
    x = @registers.get(register_x)
    y = @registers.get(register_y)
    sprite_content.bytes.each_with_index do |sprite_row, row_index|
      sprite_row.to_s(2).rjust(8, '0').split("").each_with_index do |sprite_pixel, column_index|
        if sprite_pixel == '1'
          @display.toggle_pixel(x + column_index, y + row_index)
        end
      end
    end
  end

  def render
    system("clear") || system("cls")
    puts @display.output_as_string
  end
end
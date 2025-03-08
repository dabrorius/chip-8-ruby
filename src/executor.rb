require_relative "./registers"
require_relative "./display"
require_relative "./const"
require_relative "./commands/navigation"
require_relative "./commands/register_manipulation"

require_relative "./command_parser/skip_if_literal_equal"
require_relative "./command_parser/skip_if_literal_not_equal"
require_relative "./command_parser/skip_if_register_equal"
require_relative "./command_parser/skip_if_register_not_equal"

class Executor
  include Commands::Navigation
  include Commands::RegisterManipulation

  attr_reader :registers
  attr_accessor :pc

  def initialize
    @registers = Registers.new
    @memory = "".b
    @pc = Const::LOAD_PROGRAM_ADDRESS
    @display = Display.new
    @index_register = 0
    @stack_pointer = []
    @vf_register = 0

    @command_parsers = [
      CommandParser::SkipIfLiteralEqual.new(self),
      CommandParser::SkipIfLiteralNotEqual.new(self),
      CommandParser::SkipIfRegisterEqual.new(self),
      CommandParser::SkipIfRegisterNotEqual.new(self)
    ]
  end

  def load_program(code)
    @memory = @memory.ljust(Const::LOAD_PROGRAM_ADDRESS)[..Const::LOAD_PROGRAM_ADDRESS]
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
    in [0, 0, 0xE, 0xE] # 00EE | RET | return from subroutine
      execute_ret
    in [0, 0, 0xE, 0] # 00E0 | CLS | clears the display
      execute_cls
    in [1, n1, n2, n3] # 1NNN | JP | jump to location NNN
      execute_jp(n1 * 0x100 + n2 * 0x10 + n3)
    in [2, n1, n2, n3] # 2NNN | CALL | all subroutine at location NNN
      execute_call(n1 * 0x100 + n2 * 0x10 + n3)
    in [6, x, n1, n2] # 6XNN | LD | loads register X with value NN
      execute_ld(x, n1 * 0x10 + n2)
    in [7, x, n1, n2] # 7XNN | ADD | adds value NN to register X
      execute_add(x, n1 * 0x10 + n2)
    in [8, x, y, 0] # 8XY0 | LDR | loads register X with value from register Y
      execute_ldr(x, y)
    in [8, x, y, 1] # 8XY1 | OR | does bitwise OR on registers X and Y and stores result in X
      execute_or(x, y)
    in [8, x, y, 2] # 8XY2 | AND | does bitwise AND on registers X and Y and stores result in X
      execute_and(x, y)
    in [8, x, y, 3] # 8XY3 | XOR | does bitwise XOR on registers X and Y and stores result in X
      execute_xor(x, y)
    in [8, x, y, 4] # 8XY4 | RADD | add registers X and Y and store results in X
      execute_radd(x, y)
    in [8, x, y, 5] # 8XY5 | RSUB | subtract registers X and Y and store results in X
      execute_rsub(x, y)
    in [8, x, y, 6] # 8XY6 | SHR | does bitwise XOR on registers X and Y and stores result in X
      execute_shr(x)
    in [8, x, y, 7] # 8XY7 | RSUBN | subtract registers Y and X and store results in X
      execute_rsubn(x, y)
    in [8, x, y, 0xE] # 8XY5 | SHL | subtract registers X and Y and store results in X
      execute_shl(x)
    in [0xA, n1, n2, n3] # ANNN | ILD | loads I register with value NNN
      execute_ild(n1 * 0x100 + n2 * 0x10 + n3)
    in [0xD, x, y, n] # DXYN | DRW | draws sprite to display
      execute_drw(x, y, n)
    in [0xF, x, 5, 5] # FX55 | WDI | writes registers V0 to Vx to memory locations starting at I register
      execute_wdi(x)
    in [0xF, x, 6, 5] # FX65 | LDI | loads registers V0 to Vx with values from memory location in I register
      execute_ldi(x)
    in [0xF, x, 3, 3] # FX33 | BCD | loads registers V0 to Vx with values from memory location in I register
      execute_bcd(x)
    in [0xF, x, 1, 0xE] # FX1E | IADD | adds I register and Vx and stores to I register
      execute_iadd(x)
    else
      parser_results = @command_parsers.map do |parser|
        parser.match_and_call(command_hex_array)
      end

      unless parser_results.all? false
        fail "Reached unknown command #{command_hex_array.map { |n| n.to_s(16).upcase }.join }"
      end
    end
  end

  def current_command
    first_part = @memory[@pc..@pc+1]
  end

  def next_command!
    @pc += Const::COMMAND_SIZE
  end

  def execute_cls
    @display.clear
    next_command!
  end

  def execute_ild(value)
    @index_register = value
    next_command!
  end

  def execute_drw(register_x, register_y, n)
    sprite_content = @memory[@index_register..(@index_register + n - 1)]
    x = @registers.get(register_x)
    y = @registers.get(register_y)
    is_any_erased = false
    sprite_content.bytes.each_with_index do |sprite_row, row_index|
      sprite_row.to_s(2).rjust(8, '0').split("").each_with_index do |sprite_pixel, column_index|
        if sprite_pixel == '1'
          is_erased = @display.toggle_pixel(x + column_index, y + row_index)
          is_any_erased = is_any_erased || is_erased
        end
      end
    end
    @vf_register = is_any_erased
    next_command!
  end

  def render
    system("clear") || system("cls")
    puts @display.output_as_string
  end
end
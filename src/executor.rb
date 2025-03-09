require_relative "./registers"
require_relative "./display"
require_relative "./const"
require_relative "./commands/register_manipulation"

INSTRUCTION_PARSERS_PATH = "./instruction_parser/".freeze

class Executor
  include Commands::RegisterManipulation

  attr_reader :registers, :display
  attr_accessor :pc, :index_register, :vf_register, :memory, :stack_pointer

  def initialize
    @registers = Registers.new
    @memory = "".b
    @pc = Const::LOAD_PROGRAM_ADDRESS
    @display = Display.new
    @index_register = 0
    @stack_pointer = []
    @vf_register = 0

    # Dynamically load all command parsers
    # Assume each file contains a class with camel case version of the file name
    command_parser_files = Dir.glob(File.join(__dir__, INSTRUCTION_PARSERS_PATH, '*.rb'))
    @command_parsers = command_parser_files.map do |command_parser_path|
      require_relative command_parser_path
      file_name = command_parser_path.split("/").last
      camel_case_name = file_name.gsub(".rb", "").split("_").map(&:capitalize).join
      Object.const_get("InstructionParser::#{camel_case_name}").new(self)
    end
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
    in [0xF, x, 5, 5] # FX55 | WDI | writes registers V0 to Vx to memory locations starting at I register
      execute_wdi(x)
    in [0xF, x, 6, 5] # FX65 | LDI | loads registers V0 to Vx with values from memory location in I register
      execute_ldi(x)
    else
      parser_results = @command_parsers.map do |parser|
        parser.match_and_call(command_hex_array)
      end

      if parser_results.all? { |e| e == false }
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

  def render
    system("clear") || system("cls")
    puts @display.output_as_string
  end
end
require_relative "./registers"
require_relative "./display"
require_relative "./const"

INSTRUCTION_PARSERS_PATH = "./instruction_parser/".freeze

class Executor
  attr_reader :registers, :display
  attr_accessor :pc, :index_register, :vf_register, :memory, :stack_pointer, :delay_register

  def initialize
    @registers = Registers.new
    @memory = "".b
    @pc = Const::LOAD_PROGRAM_ADDRESS
    @display = Display.new
    @index_register = 0
    @stack_pointer = []
    @vf_register = 0
    @delay_register = 0

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
    @delay_register -= 1 if @delay_register > 0
    
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

    parser_results = @command_parsers.map do |parser|
      parser.match_and_call(command_hex_array)
    end

    if parser_results.all? { |e| e == false }
      fail "Reached unknown command #{command_hex_array.map { |n| n.to_s(16).upcase }.join }"
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
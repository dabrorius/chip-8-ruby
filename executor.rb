require_relative "./registers"
require_relative "./decoder"

LOAD_PROGRAM_ADDRESS = 0x200
COMMAND_SIZE = 4

class Executor
  def initialize
    @registers = Registers.new
    @memory = Array.new(0xFFF, 0)
    @pc = LOAD_PROGRAM_ADDRESS
  end

  def load_program(code)
    code.split("").each_with_index do |v, i|
      @memory[LOAD_PROGRAM_ADDRESS + i] = v
    end
  end

  def execute_program
    while current_command != "00EE"
      execute_current_command
    end
  end

  def inspect_registers
    (0..0xF).map do |index|
      @registers.get(index)
    end
  end

  private

  def execute_current_command
    parsed_command = Decoder.decode(current_command)

    case parsed_command[0]
    when :ld
      execute_ld(parsed_command[1], parsed_command[2])
    end

    @pc += COMMAND_SIZE
  end

  def current_command
    @memory[@pc..@pc + COMMAND_SIZE - 1].join
  end

  def execute_ld(position, value)
    @registers.set(position, value)
  end
end
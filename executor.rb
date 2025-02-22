require_relative "./registers"

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
    # Conver HEX string "620F" to array of integers [6, 2, 0 15]
    command_hex_array = current_command.split("").map { |c| c.to_i(16) }

    case command_hex_array
    in [6, x, n1, n2] # 6XNN | LD | loads register X with value NN
      execute_ld(x, n1 * 0x10 + n2)
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
require_relative "./registers"
require_relative "./display"

LOAD_PROGRAM_ADDRESS = 0x200
COMMAND_SIZE = 4

class Executor
  def initialize
    @registers = Registers.new
    @memory = Array.new(0xFFF, 0)
    @pc = LOAD_PROGRAM_ADDRESS
    @display = Display.new
  end

  def load_program(code)
    code.split("").each_with_index do |v, i|
      @memory[LOAD_PROGRAM_ADDRESS + i] = v
    end
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

  private

  def execute_current_command
    # Conver HEX string "620F" to array of integers [6, 2, 0 15]
    command_hex_array = current_command.split("").map { |c| c.to_i(16) }

    case command_hex_array
    in [0, 0, 0xE, 0] # 00E0 | CLS | clears the display
      execute_cls
    in [6, x, n1, n2] # 6XNN | LD | loads register X with value NN
      execute_ld(x, n1 * 0x10 + n2)
    in [0, 0, 0xE, 0xE] # 00EE | RET | return from subroutine
      execute_ret
    else
      fail "Reached unknown command #{current_command} -> #{command_hex_array}"
    end

    @pc += COMMAND_SIZE unless @pc.nil?
  end

  def current_command
    @memory[@pc..@pc + COMMAND_SIZE - 1].join
  end

  def execute_ld(position, value)
    @registers.set(position, value)
  end

  def execute_ret
    # For now set PC to nil to indicate end of program
    @pc = nil
  end

  def execute_cls
    @display.clear
  end

  def render
    system("clear") || system("cls")
    puts @display.output_as_string
  end
end
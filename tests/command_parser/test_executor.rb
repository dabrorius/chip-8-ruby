require_relative "../../src/const"
require_relative "../../src/registers"

class TestExecutor
  attr_reader :registers, :display
  attr_accessor :pc

  def initialize(display: nil)
    @pc = Const::LOAD_PROGRAM_ADDRESS
    @registers = Registers.new
    @memory = "".b
    @index_register = 0
    @vf_register = 0
    @stack_pointer = []
    @display = display
  end
end
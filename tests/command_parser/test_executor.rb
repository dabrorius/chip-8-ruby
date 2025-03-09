require_relative "../../src/const"
require_relative "../../src/registers"

class TestExecutor
  attr_reader :registers, :display
  attr_accessor :pc, :index_register, :memory, :vf_register

  def initialize(display: nil, memory: "".b, index_register: 0)
    @pc = Const::LOAD_PROGRAM_ADDRESS
    @registers = Registers.new
    @memory = memory
    @index_register = index_register
    @vf_register = 0
    @stack_pointer = []
    @display = display
  end
end
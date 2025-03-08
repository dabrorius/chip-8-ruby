require "minitest/autorun"
require_relative "../src/commands/register_manipulation.rb"
require_relative "../registers.rb"

class TestExecutor
  attr_reader :pc, :registers

  def initialize(pc=0x200)
    @pc = pc
    @registers = Registers.new
  end

  include Commands::RegisterManipulation
end

class RegistersTest < Minitest::Test
  def test_execute_add
    executor = TestExecutor.new

    executor.registers.set(1, 50)

    assert_equal 0x200, executor.pc
    assert_equal 50, executor.registers.get(1)

    executor.execute_add(1, 7)

    assert_equal 0x202, executor.pc
    assert_equal 57, executor.registers.get(1)

    executor.execute_add(1, 200)
    assert_equal 1, executor.registers.get(1)
  end
end

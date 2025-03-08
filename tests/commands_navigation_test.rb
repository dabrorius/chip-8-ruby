require "minitest/autorun"
require_relative "../src/commands/navigation.rb"

class TestExecutor
  attr_reader :pc, :stack_pointer

  def initialize(pc=0x200, stack_pointer = [])
    @pc = pc
    @stack_pointer = stack_pointer
  end

  include Commands::Navigation
end

class RegistersTest < Minitest::Test
  def test_execute_jp
    executor = TestExecutor.new

    assert_equal 0x200, executor.pc
    executor.execute_jp(0x204)
    assert_equal executor.pc, 0x204
  end

  def test_execute_call
    executor = TestExecutor.new

    executor.execute_call(0x300)
    assert_equal executor.pc, 0x300
    assert_equal [0x200], executor.stack_pointer

    executor.execute_call(0x100)

    assert_equal executor.pc, 0x100
    assert_equal [0x200, 0x300], executor.stack_pointer
  end

  def test_execute_ret
    executor = TestExecutor.new(0x400, [0x200, 0x300])

    assert_equal 0x400, executor.pc
    assert_equal [0x200, 0x300], executor.stack_pointer

    executor.execute_ret
    assert_equal 0x302, executor.pc
    assert_equal [0x200], executor.stack_pointer

    executor.execute_ret
    assert_equal 0x202, executor.pc
    assert_equal [], executor.stack_pointer

    executor.execute_ret
    assert_nil executor.pc
    assert_equal [], executor.stack_pointer
  end
end

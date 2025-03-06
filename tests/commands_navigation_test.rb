require "minitest/autorun"
require_relative "../src/commands/navigation.rb"

class TestExecutor
  attr_reader :pc, :stack_pointer

  def init
    @pc = nil
    @stack_pointer = []
  end

  include Commands::Navigation
end

class RegistersTest < Minitest::Test
  def test_execute_jp
    executor = TestExecutor.new

    assert_equal executor.pc, nil
    executor.execute_jp(0x204)
    assert_equal executor.pc, 0x204
  end
end

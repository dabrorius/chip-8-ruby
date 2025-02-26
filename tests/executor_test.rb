require "minitest/autorun"
require_relative "../executor"

class ExecutorTest < Minitest::Test
  def test_executing_minimal_sample
    executor = Executor.new
    executor.load_program("610F00EE")
    executor.execute_program
    assert_equal executor.inspect_registers,
      [nil, 15, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
  end

  def test_index_register
    executor = Executor.new
    executor.load_program("A43600EE")
    executor.execute_program
    assert_equal executor.inspect_index_register, 0x436
  end
end

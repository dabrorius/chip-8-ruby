require "minitest/autorun"
require_relative "../executor"

class ExecutorTest < Minitest::Test
  def test_executing_minimal_sample
    executor = Executor.new
    executor.load_program("\x61\x0F\x00\xEE".b)
    executor.execute_program
    assert_equal executor.inspect_registers,
      [nil, 15, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
  end

  def test_index_register
    executor = Executor.new
    executor.load_program("\xA4\x36\x00\xEE".b)
    executor.execute_program
    assert_equal executor.inspect_index_register, 0x436
  end
end

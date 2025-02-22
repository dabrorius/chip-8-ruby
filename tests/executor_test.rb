require "minitest/autorun"
require_relative "../executor"

class ExecutorTest < Minitest::Test
  def test_executing_minimal_sample
    executor = Executor.new
    executor.execute([[:ld, 1, 15]])
    assert_equal executor.inspect_registers,
      [nil, 15, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
  end
end

require "minitest/autorun"
require_relative "./test_executor"
require_relative "../../src/instruction_parser/set_delay_timer"

module InstructionParser
  class SetDelayTimerTest < Minitest::Test
    def test_match_and_call
      executor = TestExecutor.new
      instruction_parser = InstructionParser::SetDelayTimer.new(executor)

      executor.registers.set(3, 0x10)

      instruction_parser.match_and_call([0xF, 3, 1, 5])
      assert_equal 0x10, executor.delay_register
    end
  end
end
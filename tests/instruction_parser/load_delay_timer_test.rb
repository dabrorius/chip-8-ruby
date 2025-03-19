require "minitest/autorun"
require_relative "./test_executor"
require_relative "../../src/instruction_parser/load_delay_timer"

module InstructionParser
  class LoadDelayTimerTest < Minitest::Test
    def test_match_and_call
      executor = TestExecutor.new(delay_register: 0x05)
      instruction_parser = InstructionParser::LoadDelayTimer.new(executor)


      instruction_parser.match_and_call([0xF, 1, 0, 7])
      assert_equal 0x05, executor.registers.get(1)
    end
  end
end
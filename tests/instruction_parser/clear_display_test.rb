require "minitest/autorun"
require_relative "./test_executor"
require_relative "../../src/instruction_parser/clear_display"

module InstructionParser
  class ClearDisplayTest < Minitest::Test
    def test_match_and_call
      display_mock = Minitest::Mock.new
      display_mock.expect(:clear, nil)

      executor = TestExecutor.new(display: display_mock)
      instruction_parser = InstructionParser::ClearDisplay.new(executor)

      instruction_parser.match_and_call([0, 0, 0xE, 0])

      display_mock.verify
      assert_equal 0x202, executor.pc
    end
  end
end
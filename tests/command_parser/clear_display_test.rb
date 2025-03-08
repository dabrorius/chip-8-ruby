require "minitest/autorun"
require_relative "./test_executor"
require_relative "../../src/command_parser/clear_display"

module CommandParser
  class ClearDisplayTest < Minitest::Test
    def test_match_and_call
      display_mock = Minitest::Mock.new
      display_mock.expect(:clear, nil)

      executor = TestExecutor.new(display: display_mock)
      command_parser = CommandParser::ClearDisplay.new(executor)

      command_parser.match_and_call([0, 0, 0xE, 0])

      display_mock.verify
      assert_equal 0x202, executor.pc
    end
  end
end
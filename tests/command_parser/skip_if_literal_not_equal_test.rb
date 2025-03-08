require "minitest/autorun"
require_relative "./test_executor"
require_relative "../../src/command_parser/skip_if_literal_not_equal"

module CommandParser
  class SkipIfLiteralNotEqualTest < Minitest::Test
    def test_match_and_call
      executor = TestExecutor.new
      command_parser = CommandParser::SkipIfLiteralNotEqual.new(executor)

      # When values are equal it moves to next command
      executor.registers.set(1, 0x22)
      assert_equal 0x200, executor.pc
      command_parser.match_and_call([4, 1, 2, 2])
      assert_equal 0x202, executor.pc

      # When values are not equal it skips a command command
      command_parser.match_and_call([4, 1, 2, 4])
      assert_equal 0x206, executor.pc
    end
  end
end
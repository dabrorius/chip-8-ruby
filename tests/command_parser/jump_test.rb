require "minitest/autorun"
require_relative "./test_executor"
require_relative "../../src/command_parser/jump"

module CommandParser
  class JumpTest < Minitest::Test
    def test_match_and_call
      executor = TestExecutor.new
      command_parser = CommandParser::Jump.new(executor)

      assert_equal 0x200, executor.pc
      command_parser.match_and_call([1, 1, 7, 5])

      assert_equal 0x175, executor.pc
    end
  end
end
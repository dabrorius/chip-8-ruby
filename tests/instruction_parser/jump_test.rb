require "minitest/autorun"
require_relative "./test_executor"
require_relative "../../src/instruction_parser/jump"

module InstructionParser
  class JumpTest < Minitest::Test
    def test_match_and_call
      executor = TestExecutor.new
      instruction_parser = InstructionParser::Jump.new(executor)

      assert_equal 0x200, executor.pc
      instruction_parser.match_and_call([1, 1, 7, 5])

      assert_equal 0x175, executor.pc
    end
  end
end
require "minitest/autorun"
require_relative "./test_executor"
require_relative "../../src/instruction_parser/call"

module InstructionParser
  class CallTest < Minitest::Test
    def test_match_and_call
      executor = TestExecutor.new
      instruction_parser = InstructionParser::Call.new(executor)

      assert_equal 0x200, executor.pc
      instruction_parser.match_and_call([2, 2, 5, 0])

      assert_equal 0x250, executor.pc
      assert_equal [0x200], executor.stack_pointer

      instruction_parser.match_and_call([2, 3, 7, 5])

      assert_equal 0x375, executor.pc
      assert_equal [0x200, 0x250], executor.stack_pointer
    end
  end
end
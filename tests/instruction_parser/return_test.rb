require "minitest/autorun"
require_relative "./test_executor"
require_relative "../../src/instruction_parser/return"

module InstructionParser
  class ReturnTest < Minitest::Test
    def test_match_and_call
      executor = TestExecutor.new(stack_pointer: [0x250, 0x300])
      instruction_parser = InstructionParser::Return.new(executor)

      instruction_parser.match_and_call([0, 0, 0xE, 0xE])
      assert_equal 0x302, executor.pc
      assert_equal [0x250], executor.stack_pointer

      instruction_parser.match_and_call([0, 0, 0xE, 0xE])
      assert_equal 0x252, executor.pc
      assert_equal [], executor.stack_pointer

      instruction_parser.match_and_call([0, 0, 0xE, 0xE])
      assert_nil executor.pc
      assert_equal [], executor.stack_pointer
    end
  end
end
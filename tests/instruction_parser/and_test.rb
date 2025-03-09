require "minitest/autorun"
require_relative "./test_executor"
require_relative "../../src/instruction_parser/and"

module InstructionParser
  class AndTest < Minitest::Test
    def test_match_and_call
      executor = TestExecutor.new
      instruction_parser = InstructionParser::And.new(executor)

      assert_equal 0x200, executor.pc

      executor.registers.set(1, 0x0F)
      executor.registers.set(2, 0xFF)

      instruction_parser.match_and_call([8, 1, 2, 2])
      assert_equal 0x0F, executor.registers.get(1)
      assert_equal 0x202, executor.pc
    end
  end
end
require "minitest/autorun"
require_relative "./test_executor"
require_relative "../../src/instruction_parser/or"

module InstructionParser
  class OrTest < Minitest::Test
    def test_match_and_call
      executor = TestExecutor.new
      instruction_parser = InstructionParser::Or.new(executor)

      assert_equal 0x200, executor.pc

      executor.registers.set(1, 0x0F)
      executor.registers.set(2, 0xF0)

      instruction_parser.match_and_call([8, 1, 2, 1])
      assert_equal 0xFF, executor.registers.get(1)
      assert_equal 0x202, executor.pc
    end
  end
end
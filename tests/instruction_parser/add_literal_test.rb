require "minitest/autorun"
require_relative "./test_executor"
require_relative "../../src/instruction_parser/add_literal"

module InstructionParser
  class AddLiteralTest < Minitest::Test
    def test_match_and_call
      executor = TestExecutor.new
      instruction_parser = InstructionParser::AddLiteral.new(executor)

      # When values are equal it skips a command
      executor.registers.set(1, 0x10)
      instruction_parser.match_and_call([7, 1, 0, 5])
      assert_equal 0x15, executor.registers.get(1)

      instruction_parser.match_and_call([7, 1, 2, 5])
      assert_equal 0x3A, executor.registers.get(1)
    end
  end
end
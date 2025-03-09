require "minitest/autorun"
require_relative "./test_executor"
require_relative "../../src/instruction_parser/load_literal"

module InstructionParser
  class LoadLiteralTest < Minitest::Test
    def test_match_and_call
      executor = TestExecutor.new
      instruction_parser = InstructionParser::LoadLiteral.new(executor)

      instruction_parser.match_and_call([6, 1, 0, 5])
      assert_equal 0x05, executor.registers.get(1)

      instruction_parser.match_and_call([6, 2, 3, 0xA])
      assert_equal 0x3A, executor.registers.get(2)
    end
  end
end
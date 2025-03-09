require "minitest/autorun"
require_relative "./test_executor"
require_relative "../../src/instruction_parser/load_register"

module InstructionParser
  class LoadLiteralTest < Minitest::Test
    def test_match_and_call
      executor = TestExecutor.new
      instruction_parser = InstructionParser::LoadRegister.new(executor)

      executor.registers.set(2, 0x05)
      executor.registers.set(3, 0x3A)

      instruction_parser.match_and_call([8, 1, 2, 0])
      assert_equal 0x05, executor.registers.get(1)

      instruction_parser.match_and_call([8, 2, 3, 0])
      assert_equal 0x3A, executor.registers.get(2)
    end
  end
end
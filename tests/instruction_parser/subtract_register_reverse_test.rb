require "minitest/autorun"
require_relative "./test_executor"
require_relative "../../src/instruction_parser/subtract_register_reverse"

module InstructionParser
  class SubtractRegisterReverseTest < Minitest::Test
    def test_match_and_call
      executor = TestExecutor.new
      instruction_parser = InstructionParser::SubtractRegisterReverse.new(executor)

      executor.registers.set(1, 0x20)
      executor.registers.set(2, 0x30)
      executor.registers.set(3, 0x05)

      instruction_parser.match_and_call([8, 1, 2, 7])
      assert_equal 0x10, executor.registers.get(1)
      assert_equal 1, executor.vf_register

      instruction_parser.match_and_call([8, 1, 3, 7])
      assert_equal 0xF5, executor.registers.get(1)
      assert_equal 0, executor.vf_register
    end
  end
end
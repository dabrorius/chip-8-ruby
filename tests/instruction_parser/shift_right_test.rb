require "minitest/autorun"
require_relative "./test_executor"
require_relative "../../src/instruction_parser/shift_right"

module InstructionParser
  class ShiftRightTest < Minitest::Test
    def test_match_and_call
      executor = TestExecutor.new
      instruction_parser = InstructionParser::ShiftRight.new(executor)

      assert_equal 0x200, executor.pc

      # Binary 0000 0101
      executor.registers.set(1, 0x05)

      instruction_parser.match_and_call([8, 1, 0, 6])

      # Binary 0000 0010
      assert_equal 0x2, executor.registers.get(1)
      assert_equal 1, executor.vf_register

      instruction_parser.match_and_call([8, 1, 0, 6])

      # Binary 0000 0001
      assert_equal 0x1, executor.registers.get(1)
      assert_equal 0, executor.vf_register
    end
  end
end
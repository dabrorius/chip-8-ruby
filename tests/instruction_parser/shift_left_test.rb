require "minitest/autorun"
require_relative "./test_executor"
require_relative "../../src/instruction_parser/shift_left"

module InstructionParser
  class ShiftLeftTest < Minitest::Test
    def test_match_and_call
      executor = TestExecutor.new
      instruction_parser = InstructionParser::ShiftLeft.new(executor)

      assert_equal 0x200, executor.pc

      # Binary 1010 0000
      executor.registers.set(1, 0xA0)

      instruction_parser.match_and_call([8, 1, 0, 0xE])

      # Binary 0100 0000
      assert_equal 0x40, executor.registers.get(1)
      assert_equal 1, executor.vf_register

      instruction_parser.match_and_call([8, 1, 0, 0xE])

      # Binary 1000 0000
      assert_equal 0x80, executor.registers.get(1)
      assert_equal 0, executor.vf_register
    end
  end
end
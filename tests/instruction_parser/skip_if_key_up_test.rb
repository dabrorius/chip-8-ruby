require "minitest/autorun"
require_relative "./test_executor"
require_relative "../../src/instruction_parser/skip_if_key_up"

module InstructionParser
  class SkipIfKeyDownTest < Minitest::Test
    def test_match_and_call
      executor = TestExecutor.new(keys_down: [1])
      instruction_parser = InstructionParser::SkipIfKeyUp.new(executor)

      # When values are equal it skips a command
      executor.registers.set(1, 1)
      executor.registers.set(2, 2)
      executor.registers.set(3, 0xF)

      assert_equal 0x200, executor.pc
      instruction_parser.match_and_call([0xE, 1, 0xA, 1])
      assert_equal 0x202, executor.pc

      instruction_parser.match_and_call([0xE, 2, 0xA, 1])
      assert_equal 0x206, executor.pc

      instruction_parser.match_and_call([0xE, 3, 0xA, 1])
      assert_equal 0x20A, executor.pc
    end
  end
end
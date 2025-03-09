require "minitest/autorun"
require_relative "./test_executor"
require_relative "../../src/instruction_parser/add_to_index_register"

module InstructionParser
  class AddToIndexRegisterTest < Minitest::Test
    def test_match_and_call
      executor = TestExecutor.new(index_register: 0x100)
      instruction_parser = InstructionParser::AddToIndexRegister.new(executor)

      assert_equal 0x200, executor.pc

      executor.registers.set(1, 0x10)
      executor.registers.set(2, 0xFF)

      instruction_parser.match_and_call([0xF, 1, 1, 0xE])
      assert_equal (0x100 + 0x10), executor.index_register

      instruction_parser.match_and_call([0xF, 2, 1, 0xE])
      assert_equal (0x100 + 0x10 + 0xFF), executor.index_register

      # Check overflow
      270.times do
        instruction_parser.match_and_call([0xF, 2, 1, 0xE])
      end

      assert_equal 0xF01, executor.index_register
    end
  end
end
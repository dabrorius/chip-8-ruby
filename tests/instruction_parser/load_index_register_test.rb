require "minitest/autorun"
require_relative "./test_executor"
require_relative "../../src/instruction_parser/load_index_register"

module InstructionParser
  class LoadIndexRegisterTest < Minitest::Test
    def test_match_and_call
      executor = TestExecutor.new(index_register: 0x100)
      instruction_parser = InstructionParser::LoadIndexRegister.new(executor)

      assert_equal 0x200, executor.pc
      instruction_parser.match_and_call([0xA, 3, 1, 4])

      assert_equal 0x314, executor.index_register
      assert_equal 0x202, executor.pc
    end
  end
end
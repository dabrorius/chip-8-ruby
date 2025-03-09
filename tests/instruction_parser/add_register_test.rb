require "minitest/autorun"
require_relative "./test_executor"
require_relative "../../src/instruction_parser/add_register"

module InstructionParser
  class AddRegisterTest < Minitest::Test
    def test_match_and_call
      executor = TestExecutor.new
      instruction_parser = InstructionParser::AddRegister.new(executor)

      executor.registers.set(1, 0x30)
      executor.registers.set(2, 0xF0)
      executor.registers.set(3, 0x2F)

      instruction_parser.match_and_call([8, 1, 3, 4])
      assert_equal 0x5F, executor.registers.get(1)
      assert_equal 0, executor.vf_register

      instruction_parser.match_and_call([8, 2, 3, 4])
      assert_equal 0x1F, executor.registers.get(2)
      assert_equal 1, executor.vf_register
    end
  end
end
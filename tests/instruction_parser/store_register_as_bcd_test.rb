require "minitest/autorun"
require_relative "./test_executor"
require_relative "../../src/instruction_parser/store_register_as_bcd"

module InstructionParser
  class StoreRegisterAsBcdTest < Minitest::Test
    def test_match_and_call
    executor = TestExecutor.new(memory: "\xAA\xBB\xCC\xDD\xEE".b, index_register: 1)
    instruction_parser = InstructionParser::StoreRegisterAsBcd.new(executor)

    executor.registers.set(1, 125)

    instruction_parser.match_and_call([0xF, 1, 3, 3])

    assert_equal "\xAA\x01\x02\x05\xEE".b, executor.memory
    end
  end
end
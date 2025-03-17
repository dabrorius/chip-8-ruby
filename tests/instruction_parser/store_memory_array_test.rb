require "minitest/autorun"
require_relative "./test_executor"
require_relative "../../src/instruction_parser/load_memory_array"

module InstructionParser
  class StoreMemoryArrayTest < Minitest::Test
    def test_match_and_call
      executor = TestExecutor.new(memory: "\xAA\xBB\xCC\xDD\xEE".b, index_register: 2)
      instruction_parser = InstructionParser::StoreMemoryArray.new(executor)

      executor.registers.set(0, 0x0F)
      executor.registers.set(1, 0xAD)
      instruction_parser.match_and_call([0xF, 1, 5, 5])

      assert_equal "\xAA\xBB\x0F\xAD\xEE".b, executor.memory
    end
  end
end
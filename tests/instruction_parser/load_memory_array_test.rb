require "minitest/autorun"
require_relative "./test_executor"
require_relative "../../src/instruction_parser/load_memory_array"

module InstructionParser
  class LoadMemoryArrayTest < Minitest::Test
    def test_match_and_call
      executor = TestExecutor.new(memory: "\xAA\xBB\xCC\xDD\xEE".b, index_register: 2)
      instruction_parser = InstructionParser::LoadMemoryArray.new(executor)

      instruction_parser.match_and_call([0xF, 1, 6, 5])

      assert_equal 0xCC, executor.registers.get(0)
      assert_equal 0xDD, executor.registers.get(1)
    end
  end
end
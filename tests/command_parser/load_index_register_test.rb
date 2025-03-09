require "minitest/autorun"
require_relative "./test_executor"
require_relative "../../src/command_parser/load_index_register"

module CommandParser
  class LoadIndexRegisterTest < Minitest::Test
    def test_match_and_call
      executor = TestExecutor.new(index_register: 0x100)
      command_parser = CommandParser::LoadIndexRegister.new(executor)

      assert_equal 0x200, executor.pc
      command_parser.match_and_call([0xA, 3, 1, 4])

      assert_equal 0x314, executor.index_register
      assert_equal 0x202, executor.pc
    end
  end
end
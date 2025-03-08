require "minitest/autorun"
require_relative "./test_executor"
require_relative "../../src/command_parser/skip_if_register_equal"

module CommandParser
  class SkipIfRegisterEqualTest < Minitest::Test
    def test_match_and_call
      executor = TestExecutor.new
      command_parser = CommandParser::SkipIfRegisterEqual.new(executor)

      # When values are equal it skips a command
      executor.registers.set(1, 0x22)
      executor.registers.set(2, 0x22)
      executor.registers.set(3, 0x35)
      assert_equal 0x200, executor.pc
      command_parser.match_and_call([5, 1, 2, 0])
      assert_equal 0x204, executor.pc

      # When values are not equal it moves to next command
      command_parser.match_and_call([5, 1, 3, 0])
      assert_equal 0x206, executor.pc
    end
  end
end
require "minitest/autorun"
require_relative "./test_executor"
require_relative "../../src/instruction_parser/draw"

module InstructionParser
  class DrawTest < Minitest::Test
    def test_match_and_call
      display_mock = Minitest::Mock.new

      # Drawing starts at 0x2 - so we draw 0x02 and 0x08
      # 0x02 = 0000 0010
      # 0x08 = 0000 1000
      executor = TestExecutor.new(
        memory: "\x00\x00\x02\x08\x10".b,
        display: display_mock,
        index_register: 0x2
      )

      # Sprite is drawn at 5, 8
      executor.registers.set(0, 5)
      executor.registers.set(1, 8)

      instruction_parser = InstructionParser::Draw.new(executor)

      # Drawing pixels
      display_mock.expect(:toggle_pixel, 0, [11, 8])
      display_mock.expect(:toggle_pixel, 0, [9, 9])

      instruction_parser.match_and_call([0xD, 0, 1, 2])

      display_mock.verify
      assert_equal 0, executor.vf_register
      assert_equal 0x202, executor.pc

      # Erasing pixels
      display_mock.expect(:toggle_pixel, 1, [11, 8])

      instruction_parser.match_and_call([0xD, 0, 1, 1])

      display_mock.verify
      assert_equal 1, executor.vf_register
      assert_equal 0x204, executor.pc
    end
  end
end
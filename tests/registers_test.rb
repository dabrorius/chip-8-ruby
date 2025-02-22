require "minitest/autorun"
require_relative "../registers.rb"

class RegistersTest < Minitest::Test
  def test_setting_and_getting
    registers = Registers.new
    registers.set(1, 23)
    assert_equal registers.get(1), 23

    registers.set(0xF, 47)
    assert_equal registers.get(0xF), 47
  end

  def test_position_range_errors
    registers = Registers.new

    error = assert_raises ArgumentError do
      registers.set(-1, 50)
    end
    assert_equal error.message, "Position 0x-1 is out of range"

    error = assert_raises ArgumentError do
      registers.set(0x10, 50)
    end
    assert_equal error.message, "Position 0x10 is out of range"

    error = assert_raises ArgumentError do
      registers.get(-1)
    end
    assert_equal error.message, "Position 0x-1 is out of range"

    error = assert_raises ArgumentError do
      registers.get(0x10)
    end
    assert_equal error.message, "Position 0x10 is out of range"
  end
end

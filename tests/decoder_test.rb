require "minitest/autorun"
require_relative "../decoder.rb"

class DecoderTest < Minitest::Test
	def test_basic_decoding
		result = Decoder.decode("6210")
		assert_equal result, [[:ld, 2, 16]]
	end
end
module Decoder
  def self.decode(command_code)
    case command_code
    when /6.../ # 6XNN loads register X with value NN
      [:ld, command_code[1].to_i(16), command_code[2..3].to_i(16)]
    end
  end
end
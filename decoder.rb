module Decoder
  def self.decode(code)
    code.scan(/.{1,4}/).map do |coded_command|
      case coded_command
      when /6.../ # 6XNN loads register X with value NN
        [:ld, coded_command[1].to_i(16), coded_command[2..3].to_i(16)]
      end
    end
  end
end
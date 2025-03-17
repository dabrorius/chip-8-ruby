require_relative "../const"

module InstructionParser
  # Format: Fx33
  # Stores value from register Vx as binary coded decimal number.
  # Takes decimal value of Vx and stores hundreds at I, tens at I+1 and ones at I+2.
  class StoreRegisterAsBcd
    def initialize(executor)
      @executor = executor
    end

    def match_and_call(command_hex_array)
      if command_hex_array in [0xF, x, 3, 3]
        call(x)
        return true
      end
      false
    end

    private

    def call(register)
      register_value = @executor.registers.get(register)

      hundreds = register_value / 100
      tens = (register_value / 10) % 10
      ones = register_value % 10

      @executor.memory[@executor.index_register] = ["0#{hundreds.to_s(16)}"].pack("H*")
      @executor.memory[@executor.index_register + 1] = ["0#{tens.to_s(16)}"].pack("H*")
      @executor.memory[@executor.index_register + 2] = ["0#{ones.to_s(16)}"].pack("H*")

      @executor.pc += Const::COMMAND_SIZE
    end
  end
end

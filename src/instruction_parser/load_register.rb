require_relative "../const"

module InstructionParser
  # Format: 8xyn
  # Loads value from register Vy to register Vx
  class LoadRegister
    def initialize(executor)
      @executor = executor
    end

    def match_and_call(command_hex_array)
      if command_hex_array in [8, x, y, 0]
        call(x, y)
        return true
      end
      false
    end

    private

    def call(register_x, register_y)
      value = @executor.registers.get(register_y)
      @executor.registers.set(register_x, value)
      @executor.pc += Const::COMMAND_SIZE
    end
  end
end

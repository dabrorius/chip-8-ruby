require_relative "./registers"

class Executor
	def initialize
		@registers = Registers.new
	end

	def execute(commands)
		commands.each do |command|
			command_name = command[0]
			case command_name
			when :ld
				cmd_ld(command[1], command[2])
			end
		end
	end

	def inspect_registers
		(0..0xF).map do |index|
			@registers.get(index)
		end
	end

	private

	def cmd_ld(position, value)
		@registers.set(position, value)
	end
end
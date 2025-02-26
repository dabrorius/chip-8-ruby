require "./executor"

rom_file = File.binread("./example_roms/1-chip8-logo.ch8")
rom_hex_content = rom_file.unpack("H*").first

puts "== ROM content =="
puts rom_hex_content
puts "== END =="

executor = Executor.new
executor.load_program(rom_hex_content)
executor.execute_program
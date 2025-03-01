require "./executor"

rom_content = File.binread("./example_roms/2-ibm-logo.ch8")

puts "== ROM content =="
puts rom_content
puts "== END =="

executor = Executor.new
executor.load_program(rom_content)
executor.execute_program
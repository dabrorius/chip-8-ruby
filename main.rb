require 'gosu'
require "./src/executor"

PIXEL_SIZE = 8
PIXELS_X = 64
PIXELS_Y = 32

class Chip8 < Gosu::Window
  def initialize
    super PIXELS_X * PIXEL_SIZE, PIXELS_Y * PIXEL_SIZE

    self.caption = "Chip 8"

    rom_content = File.binread("./example_roms/6-keypad.ch8")

    @executor = Executor.new
    @executor.load_program(rom_content)

    @keys_down = []    
  end

  def button_down(id)
    value = case id
      when Gosu::KB_1 then 1
      when Gosu::KB_2 then 2
      when Gosu::KB_3 then 3
      when Gosu::KB_4 then 4
      when Gosu::KB_5 then 5
      when Gosu::KB_6 then 6
      when Gosu::KB_7 then 7
      when Gosu::KB_8 then 8
      when Gosu::KB_9 then 9
      when Gosu::KB_0 then 0
      when Gosu::KB_A then 0xA
      when Gosu::KB_B then 0xB
      when Gosu::KB_C then 0xC
      when Gosu::KB_D then 0xD
      when Gosu::KB_E then 0xE
      when Gosu::KB_F then 0xF
    end

    @keys_down << value unless @keys_down.include?(value)
  end

  def button_up(id)
    value = case id
      when Gosu::KB_1 then 1
      when Gosu::KB_2 then 2
      when Gosu::KB_3 then 3
      when Gosu::KB_4 then 4
      when Gosu::KB_5 then 5
      when Gosu::KB_6 then 6
      when Gosu::KB_7 then 7
      when Gosu::KB_8 then 8
      when Gosu::KB_9 then 9
      when Gosu::KB_0 then 0
      when Gosu::KB_A then 0xA
      when Gosu::KB_B then 0xB
      when Gosu::KB_C then 0xC
      when Gosu::KB_D then 0xD
      when Gosu::KB_E then 0xE
      when Gosu::KB_F then 0xF
    end

    @keys_down.delete(value)
  end

  def update
    @executor.keys_down = @keys_down
    @executor.step if @executor.can_step?
  end

  def draw
    (0..PIXELS_X-1).each do |column|
      (0..PIXELS_Y-1).each do |row|
        next unless @executor.get_display_pixel(column, row)

        x1 = column * PIXEL_SIZE
        y1 = row * PIXEL_SIZE
        x2 = x1 + PIXEL_SIZE
        y2 = y1
        x3 = x1 + PIXEL_SIZE
        y3 = y1 + PIXEL_SIZE
        x4 = x1
        y4 = y1 + PIXEL_SIZE

        color = Gosu::Color::WHITE

        Gosu.draw_quad(
          x1, y1, color,  # Top-left
          x2, y2, color,  # Top-right
          x3, y3, color,  # Bottom-right
          x4, y4, color   # Bottom-left
        )
      end
    end
  end
end

Chip8.new.show
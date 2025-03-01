require 'gosu'
require "./executor"

PIXEL_SIZE = 8
PIXELS_X = 64
PIXELS_Y = 32

class Chip8 < Gosu::Window
  def initialize
    super PIXELS_X * PIXEL_SIZE, PIXELS_Y * PIXEL_SIZE

    self.caption = "Chip 8"

    rom_content = File.binread("./example_roms/2-ibm-logo.ch8")

    @executor = Executor.new
    @executor.load_program(rom_content)
  end

  def update
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
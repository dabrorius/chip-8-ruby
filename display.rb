class Display
  def initialize
    initialize_screen
  end

  def set_pixel(column, row, value=true)
    @pixels[row][column] = value
  end

  def output_as_string
    @pixels.map do |row|
      row.map { |pixel| pixel ? '#' : '.' }.join
    end.join("\n")
  end

  private

  def initialize_screen
    @pixels = (0..31).map { Array.new(64, false) }
  end
end
class Display
  def initialize
    initialize_screen
  end

  def set_pixel(column, row, value=true)
    @pixels[row][column] = value
  end

  def get_pixel(column, row)
    @pixels[row][column]
  end

  def toggle_pixel(column, row)
    original_value = @pixels[row][column]
    @pixels[row][column] = !original_value

    original_value ? 1 : 0 # Indicates if pixel was erased
  end

  def output_as_string
    @pixels.map do |row|
      row.map { |pixel| pixel ? '#' : '.' }.join
    end.join("\n")
  end

  def clear
    initialize_screen
  end

  private

  def initialize_screen
    @pixels = (0..31).map { Array.new(64, false) }
  end
end
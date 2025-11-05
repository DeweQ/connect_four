# Connect four game class
class ConnectFour
  def initialize(field = Array.new(6) { Array.new(7) { { status: :empty } } })
    @field = field
    @rows = field.size
    @columns = field[0].size
  end

  def add_piece(color, column)
    raise ArgumentError, "Column out of range" unless column.between?(0, @columns - 1)

    field.reverse.each do |row|
      return row[column][:status] = color if row[column][:status] == :empty
    end
    raise ArgumentError, "Column overflow"
  end

  def check_for_winner
    check_rows || check_columns || check_diagonals
  end

  private

  attr_reader :field

  def check_rows
    check_direction(field.each)
  end

  def check_columns
    check_direction(field.transpose.each)
  end

  def check_diagonals
    check_direction(diagonals)
  end

  def diagonals
    diagonals = []
    @columns.times do |i|
      diagonals << collect_diagonal(0, i, 1) if @columns - i >= 4
      diagonals << collect_diagonal(0, i, -1) if i >= 3
    end
    (1..(@rows - 4)).each do |i|
      diagonals << collect_diagonal(i, 0, 1)
      diagonals << collect_diagonal(i, @columns - 1, -1)
    end
    diagonals
  end

  def collect_diagonal(row, column, direction)
    diagonal = []
    while row < @rows && column < @columns
      diagonal << field[row][column]
      row += 1
      column += direction
    end
    diagonal
  end

  def check_direction(direction)
    winner = nil
    direction.each do |array|
      winner = check_by_slice(array)
      return winner unless winner.nil?
    end
    nil
  end

  def check_by_slice(array)
    array.size.times do |i|
      slice = array.slice(i, 4)
      return nil if slice.size < 4

      return slice[0][:status] if slice.uniq.size == 1 && slice[0][:status] != :empty
    end
  end
end

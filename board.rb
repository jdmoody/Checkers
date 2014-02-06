require_relative 'piece'
class Board
  def initialize(fill_board = true)
    create_grid(fill_board)
  end
  
  def [](pos)
    row, col = pos
    @rows[row][col]
  end
  
  def []=(pos, piece)
    row, col = pos
    @rows[row][col] = piece
  end
  
  def add_piece(piece, pos)
    self[pos] = piece
  end
  
  def create_grid(fill_board)
    @rows = Array.new(8) { Array.new(8) }
    
    if fill_board
      [:red, :black].each do |color|
        fill_pieces(color)
      end
    end
  end
  
  def fill_pieces(color)
    piece_rows = (color == :red ? [0, 1, 2] : [5, 6, 7])
    piece_rows.each do |row|
      8.times do |col| 
        Piece.new([row, col], self, color) if (row + col) % 2 == 1
      end
    end
  end
  
  def render
    @rows.map do |row|
      row.map do |piece|
        piece.nil? ? "_" : piece.render
      end.join(" ")
    end.join("\n")
  end
end

board = Board.new
board[[2, 1]].perform_slide([3,2])
puts board.render
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
      [:red, :white].each do |color|
        fill_pieces(color)
      end
    end
    Piece.new([6,1], self, :white)
    Piece.new([5,2], self, :red)
    Piece.new([3,2], self, :red)
    Piece.new([1,2], self, :red)
    Piece.new([5,4], self, :red)
    Piece.new([3,4], self, :red)
    Piece.new([1,4], self, :red)
    Piece.new([5,6], self, :red)
    Piece.new([3,6], self, :red)
    Piece.new([1,6], self, :red)
    
  end
  
  def dup
    copy = Board.new(false)
    
    pieces.each do |piece|
      Piece.new(piece.pos, copy, piece.color)
    end
    
    copy
  end
  
  def fill_pieces(color)
    piece_rows = (color == :red ? [0, 1, 2] : [5, 6, 7])
    piece_rows.each do |row|
      8.times do |col| 
        Piece.new([row, col], self, color) if (row + col) % 2 == 1
      end
    end
  end
  
  def pieces
    @rows.flatten.compact
  end
  
  def render
    board = @rows.map.with_index do |row, idx1|
      "#{idx1} " + row.map.with_index do |piece, idx2|
        (piece.nil? ? "   " : piece.render).colorize(:background => ((idx1 + idx2) % 2 == 0 ? :green : :black))
      end.join("")
    end.join("\n")
    board = "   0  1  2  3  4  5  6  7\n" + board
  end
end

# custom_board = Board.new
# Piece.new([1, 1], custom_board, :red)
# Piece.new([3, 3], custom_board, :red)
# Piece.new([5, 5], custom_board, :red)
# Piece.new([6, 6], custom_board, :white)
# puts custom_board.render
# custom_board[[6, 6]].perform_moves([[4,4],[2,2],[0,0]])
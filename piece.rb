class Piece
  attr_reader :board, :color
  attr_accessor :pos, :promoted
  
  def initialize(pos, board, color, promoted = false)
    @pos, @board, @color, @promoted = pos, board, color, promoted
    
    board.add_piece(self, pos)
  end
  
  def maybe_promote
    last_row = (color == :red ? 0 : 7)
    self.promoted = true if self.pos[0] == last_row
  end
  
  def move_diffs
    if promoted
      diffs = [[1, 1], [1, -1], [-1, 1], [-1, -1]]
    else
      diffs = (color == :red ? [[1, 1], [1, -1]] : [[-1, 1], [-1, -1]])
    end
  end
  
  def on_board?(pos)
    pos.all? { |coord| coord >= 0 && coord < 8 }
  end
  
  def open?(pos)
    board[pos] == nil
  end
  
  def perform_moves
    # dup board
    # duped_board.perform_moves!
    # board.perform_moves!
  end
  
  def perform_moves!
    # single valid slide
    # single valid jumps
    # multiple valid jumps
    # tries to perform as much of sequence as possible
  end
  
  # def perform_jump(end_pos)
  #   return false unless self.valid?(end_pos)
  #   
  #   jumped = self.move_diffs
  #   jumped_pos = jumped.map do |diff|
  #     vertically_sum(self.pos, diff)
  #   end
  #   unless self.open?(jumped_position)
  #     
  #   diffs = jumped.map do |diff|
  #     diff.map { |coord| coord * 2 }
  #   end
  #   end_moves = diffs.map do |diff|
  #     vertically_sum(self.pos, diff)
  #   end
  #   return false unless end_moves.include?(end_pos)
  #   
  #   
  #   
  #   self.board[pos] = nil
  #   self.pos = end_pos
  #   self.board[pos] = self
  #   
  #   self.maybe_promote
  #   true
  # end
  
  def perform_slide(end_pos)
    return false unless self.valid?(end_pos)
    
    diffs = self.move_diffs
    end_moves = diffs.map do |diff|
      vertically_sum(self.pos, diff)
    end
    return false unless end_moves.include?(end_pos)
    
    self.board[pos] = nil
    self.pos = end_pos
    self.board[pos] = self
    
    self.maybe_promote
    true
  end
  
  def render
    promoted ? "K" : "P"
  end
  
  def valid?(pos)
    self.on_board?(pos) && self.open?(pos)
  end
  
  def valid_jump?(pos)
    
  end
  
  def vertically_sum(position, change)
      position.zip(change)
      .map { |pos, change| pos + change }
  end
end
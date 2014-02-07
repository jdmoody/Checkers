require 'colorize'
require_relative 'checkers_errors'

class Piece
  attr_reader :board, :color
  attr_accessor :pos, :promoted
  
  def initialize(pos, board, color, promoted = false)
    @pos, @board, @color, @promoted = pos, board, color, promoted
    
    board.add_piece(self, pos)
  end
  
  def enemy?(pos)
    board[pos].color != self.color
  end
  
  def maybe_promote
    last_row = (color == :red ? 7 : 0)
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
  
  def perform_moves(moves)
    valid_move_seq?(moves) ? perform_moves!(moves) : (raise InvalidMoveError)
  end
  
  def perform_moves!(moves)
    if moves.length == 1
      unless self.perform_slide(moves.first)
        raise InvalidMoveError unless self.perform_jump(moves.first)
      end
      
    else
      moves.each do |move|
        raise InvalidMoveError unless self.perform_jump(move)
      end
    end
  end
  
  def perform_jump(end_pos)
    return false unless self.valid?(end_pos)
    
    self.move_diffs.each do |diff|
      jumped_spot = vertically_sum(self.pos, diff)
      next if self.open?(jumped_spot)
      next unless self.enemy?(jumped_spot)
      
      landing_spot = vertically_sum(jumped_spot, diff)
      next unless landing_spot == end_pos
      
      board[jumped_spot].pos = nil
      board[jumped_spot] = nil
      
      board[pos] = nil
      self.pos = end_pos
      board[end_pos] = self
      maybe_promote
      return true
    end
    
    false
  end
  
  def perform_slide(end_pos)
    return false unless self.valid?(end_pos)
    
    diffs = self.move_diffs
    end_moves = diffs.map do |diff|
      vertically_sum(self.pos, diff)
    end
    return false unless end_moves.include?(end_pos)
    
    self.board[self.pos] = nil
    self.pos = end_pos
    self.board[self.pos] = self
    
    self.maybe_promote
    true
  end
  
  def render
    (promoted ? " K " : " O ").colorize(color)
  end
  
  def valid?(pos)
    self.on_board?(pos) && self.open?(pos)
  end

  def valid_move_seq?(moves)
    copy = self.board.dup
    begin
      copy[self.pos].perform_moves!(moves)
    rescue InvalidMoveError
      false
    else
      true
    end
  end
  
  def vertically_sum(position, change)
      position.zip(change)
      .map { |pos, change| pos + change }
  end
end
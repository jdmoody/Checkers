require_relative 'board'

class Game
  attr_reader :board, :players, :current_player
  
  def initialize
    @board = Board.new false
    @players = {
      :white => HumanPlayer.new(:white),
      :red   => HumanPlayer.new(:red)
    }
    @current_player = :white
  end
  
  def declare_winner
    board.print
    puts "#{current_player.capitalize} has no more pieces!"
    switch_players
    puts "#{current_player.capitalize} won!"
  end
  
  def game_over?
    board.pieces.none? { |piece| piece.color == current_player}
  end
  
  def play
    until game_over?
      board.print
      puts "#{current_player.capitalize}'s turn:"
      players[current_player].play_turn(board)
      switch_players
    end
    
    declare_winner  
  end
  
  def switch_players
    @current_player = (current_player == :white ? :red : :white)
  end
end

class HumanPlayer
  attr_reader :color
  
  def initialize(color)
    @color = color
  end
  
  def play_turn(board)
    begin
      puts "Enter the location of the piece you would like to move (e.g. 5,4)"
      piece_to_move = board[gets.chomp.split(",").map(&:to_i)]
      raise WrongPlayerPieceError unless piece_to_move.color == color
      
      puts "Enter the location(s) where you would like to move (e.g. (4,3) (3,2))"
      parsed_moves = gets.chomp.gsub(/[\(\)]/, "").split(" ")
      moves = parsed_moves.map { |move| move.split(",").map(&:to_i) }
      
      piece_to_move.perform_moves(moves)
    rescue WrongPlayerPieceError
      puts "That piece doesn't belong to you!"
      retry
    rescue InvalidMoveError
      puts "Invalid move"
      retry
    rescue PromotionError
      puts "You can't move after promoting a piece!"
      retry
    rescue
      puts "Invalid coordinates"
      retry
    end
  end
end

Game.new.play
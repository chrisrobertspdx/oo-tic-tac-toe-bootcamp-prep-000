#require_relative 'ai.rb'

class TicTacToe
  def initialize
    #@board = Array.new(9," ")
    @board = [" ","X"," "," "," ","X","O","O"," "]
    @choice
    @player = "O"
    @opponent = "X"
  end

  WIN_COMBINATIONS = [
    [0,1,2],
    [3,4,5],
    [6,7,8],
    [0,3,6],
    [1,4,7],
    [2,5,8],
    [0,4,8],
    [2,4,6]
  ]

  def display_board(board=@board)
    puts " #{board[0]} | #{board[1]} | #{board[2]} "
    puts "-----------"
    puts " #{board[3]} | #{board[4]} | #{board[5]} "
    puts "-----------"
    puts " #{board[6]} | #{board[7]} | #{board[8]} "
  end

  def input_to_index(user_input)
    user_input.to_i - 1
  end

  def move(index, current_player)
    @board[index] = current_player
  end

  def position_taken?(index)
    !(@board[index].nil? || @board[index] == " ")
  end

  def valid_move?(index)
    index.between?(0,8) && !position_taken?(index)
  end


  def turn
    if current_player == "X"
      puts "Please enter 1-9:"
      input = gets.strip
      index = input_to_index(input)
      if valid_move?(index)
        move(index, current_player)
        display_board
      else
        turn
      end
    else
      #Computer move
      #ai_move = minimax(@board)
      puts "Computer Moves:"
      depth = 0
      minimax(@board,depth)
      puts "minimax selects #{@choice}"
      ai_move = @choice;
      move(ai_move,current_player)
      #get_available_moves(@board)
      display_board
    end
  end

  def turn_count(board=@board)
    count = 0
    board.each do |space|
      if space == 'X' || space == 'O'
        count += 1
      end
    end
    count
  end

  def current_player(board=@board)
    if turn_count(board) % 2 == 0
      "X"
    else
      "O"
    end
  end

  def won?(board=@board)
    players = ["X","O"]
    players.each do |player|
      WIN_COMBINATIONS.each do |combination|
        if board[combination[0]] == player && board[combination[1]] == player && board[combination[2]] == player
          return combination
        end
      end
    end
    nil
  end

  def full?(board=@board)
    board.all? do |cell|
      !(cell.nil? || cell == " ")
    end
  end

  def draw?(board=@board)
    if won?(board) != nil || !full?(board)
      false
    else
      true
    end
  end

  def over?(board=@board)
    won?(board) || draw?(board) || full?(board)
  end

  def winner(board=@board)
    winpos = won?(board)
    if winpos
      board[winpos[0]]
    else
      winpos
    end
  end

  def play
    until over? do
      turn
    end
    if won?
      puts "Congratulations #{winner}!"
    elsif draw?
      puts "Cat's Game!"
    end
  end

  def arbmove
    @board.index(" ")
  end

def get_new_state(aboard,move)
    newboard = aboard.clone
    newboard[move] = current_player(newboard)
    newboard;
end

def get_available_moves(aboard)
    avail = aboard.each_index.select{|i| aboard[i] != "X" && aboard[i] != "O"}
    return avail
end

def minimax(aboard,depth)
    return score(aboard,depth) if over?(aboard)
    scores = [] # an array of scores
    moves = []  # an array of moves
    depth += 1
    #puts depth
    # Populate the scores array, recursing as needed
    get_available_moves(aboard).each do |move|
        possible_game = get_new_state(aboard,move)
        scores.push minimax(possible_game,depth)
        moves.push move
    end

    # Do the min or the max calculation
    if current_player(aboard) == @player
        # This is the max calculation
        max_score_index = scores.each_with_index.max[1]
        @choice = moves[max_score_index]
        return scores[max_score_index]
    else
        # This is the min calculation
        min_score_index = scores.each_with_index.min[1]
        @choice = moves[min_score_index]
        return scores[min_score_index]
    end
end

def score(board,depth)

    if winner(board) == @player
        puts "Depth: #{depth} Score:#{10-depth}"
        return 10-depth
    elsif winner(board) == @opponent
        puts "Depth: #{depth} Score:#{depth-10}"
        return depth-10
    else
        return 0
    end
end

end

class Game
  @@total_games = 0
  @@wins_player_one = 0
  @@wins_player_two = 0

  @@win = false
  @@tie = false

  def self.scoreBoard
    puts "Total games played: #{@@total_games}"
    puts "Player 1's score: #{@@wins_player_one}"
    puts "Player 2's score: #{@@wins_player_two}"
    puts "Number of ties: #{@@total_games - @@wins_player_one - @@wins_player_two}"
  end

  def self.check_win_tie(board)
    # Check rows
    board.board.each do |row|
      if row.uniq.length == 1 && row.first != '-'
        @@win = true
        return
      end
    end

    # Check columns
    (0..2).each do |col|
      column = [board.board[0][col], board.board[1][col], board.board[2][col]]
      if column.uniq.length == 1 && column.first != '-'
        @@win = true
        return
      end
    end

    # Check diagonals
    diagonal1 = [board.board[0][0], board.board[1][1], board.board[2][2]]
    if diagonal1.uniq.length == 1 && board.board[0][0] != '-'
      @@win = true
      return
    end

    diagonal2 = [board.board[0][2], board.board[1][1], board.board[2][0]]
    if diagonal2.uniq.length == 1 && board.board[0][2] != '-'
      @@win = true
      return
    end

    # Check for tie
    return unless board.board.flatten.none? { |position| position == '-' }

    @@tie = true
  end

  def self.game_reset
    @@win = false
    @@tie = false
    @@total_games += 1
  end

  def self.game_turn(player1, player2, board)
    loop do
      # Player 1 goes and checks to see if they won
      player1.choose_placement(board)
      check_win_tie(board)

      if @@win == true && @@tie == false
        puts "#{player1.name} is the winner!"
        @@wins_player_one += 1
        game_reset
        break
      end

      # Player 2 goes and checks to see if they won
      player2.choose_placement(board)
      check_win_tie(board)

      if @@win == true && @@tie == false
        puts "#{player2.name} is the winner!"
        @@wins_player_two += 1
        game_reset
        break
      end

      # Check if it's a tie
      next unless @@win == false && @@tie == true

      puts 'Game is a tie! Nobody wins!'
      game_reset
      break
    end
  end
end

class Player < Game
  attr_reader :name, :token

  def initialize(name, token)
    @name = name
    @token = token
  end

  def choose_placement(game_board)
    input = nil
    until input =~ /^[1-9]$/
      puts "#{name}, choose a number between 1-9 to place your token '#{token}':"
      input = gets.chomp
    end

    player_choice = input.to_i - 1
    row = (player_choice / 3).floor
    column = (player_choice % 3).floor

    if player_choice.between?(0, 8) && game_board.board[row][column] == '-'
      game_board.update_board(player_choice, @token)
      game_board.display_board
    else
      puts 'Invalid position or position already taken. Choose another.'
      choose_placement(game_board)
    end
  end
end

class Board < Game
  attr_accessor :board

  def initialize
    @board = [['-', '-', '-'],
              ['-', '-', '-'],
              ['-', '-', '-']]
  end

  def display_board
    @board.each do |row|
      puts row.each { |position| }.join(' ')
    end
  end

  def update_board(player_choice, token)
    row = (player_choice / 3).floor
    column = (player_choice % 3).floor
    @board[row][column] = token
  end
end

# Initialize the game
def start_game
  player1 = Player.new('Player 1', 'X')
  player2 = Player.new('Player 2', 'O')

  loop do
    board = Board.new
    Game.game_turn(player1, player2, board)

    # Display scoreboard after the game
    Game.scoreBoard

    puts 'Do you want to play again? (y/n): '
    answer = gets.chomp.downcase
    break if answer != 'y'
  end
end

start_game

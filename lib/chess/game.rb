module Chess
  class Game
    SAVED_GAME_PATH = "./data/saved_game.json"

    attr_reader :board, :player_white, :player_black, :current_player, :game_type

    def initialize
      @board = Board.new
      @player_white = Player.new(:white)
      @player_black = Player.new(:black)
      @current_player = player_white
      @game_type = nil
    end

    def play
      puts "Welcome to the game of Chess!"
      initialize_game
      choose_game_type unless @game_type

      loop do
        display_board_and_turn
        move = get_move_for_current_player
        break if move.nil?
        
        board.move_piece(move[:from], move[:to])

        if resolve_turn(move[:from], move[:to])
          break
        end

        @current_player = current_player == player_white ? player_black : player_white
      end
    end

    private

    def save_game
      f = File.new SAVED_GAME_PATH, "w+"
      data = board.to_h
      data["current_player"] = current_player.to_s
      data["game_type"] = game_type
      data["player_white_type"] = player_white.is_a?(ComputerPlayer) ? "computer" : "human"
      data["player_black_type"] = player_black.is_a?(ComputerPlayer) ? "computer" : "human"
      f.write(JSON.dump(data))
      f.close
      puts "Successfully written data to disk."
    end

    def load_game
      data = JSON.load(File.read(SAVED_GAME_PATH))
      @board = Board.from_h(data)
      @game_type = data["game_type"]

      white_type = data["player_white_type"]
      black_type = data["player_black_type"]
      @player_white = white_type == "computer" ? ComputerPlayer.new(:white) : Player.new(:white)
      @player_black = black_type == "computer" ? ComputerPlayer.new(:black) : Player.new(:black)

      @current_player = data["current_player"] == player_white.to_s ? player_white : player_black
      puts "Game successfully loaded.\n"
    end

    def initialize_game
      if File.exist? SAVED_GAME_PATH
        puts "Do you want to load previously saved game? (y/n)" 
        load_game if gets.chomp.downcase == "y"
      end
    end

    def choose_game_type
      puts "\nChoose game mode:"
      puts "1. Human vs Human"
      puts "2. Human vs Computer"
      puts "Enter your choice (1 or 2):"
      
      choice = gets.chomp
      
      case choice
      when "1"
        @game_type = "human_vs_human"
      when "2"
        @game_type = "human_vs_computer"
        puts "Do you want to play as White? (y/n)"
        if gets.chomp.downcase == "y"
          @player_black = ComputerPlayer.new(:black)
        else
          @player_white = ComputerPlayer.new(:white)
          @current_player = player_white
        end
      else
        puts "Invalid choice. Defaulting to Human vs Human."
        @game_type = "human_vs_human"
      end
    end

    def display_board_and_turn
      puts "\n#{board}"
      puts "#{current_player}'s turn"
    end

    def get_move_for_current_player
      if current_player.is_a?(ComputerPlayer)
        get_computer_move
      else
        get_human_move
      end
    end

    def get_computer_move
      puts "Computer is thinking..."
      sleep(1)
      move = current_player.make_move(board)

      puts "Computer moves: #{move[:from]} to #{move[:to]}"
      move
    end

    def get_human_move
      loop do
        puts "Enter move (e.g., '4,6 4,4' for col,row from-to), 'save' to save the game or 'exit' to quit:"
        input = gets.chomp

        return nil if input == "exit"
        if input == "save"
          save_game
          next
        end

        input = input.split
        unless valid_input?(input)
          puts "Invalid input!"
          next
        end
      
        from = input[0].split(",").map(&:to_i)
        to = input[1].split(",").map(&:to_i)
        from = [from[1], from[0]]
        to = [to[1], to[0]]
      
        unless board.valid_move?(from, to, current_player)
          puts "Invalid move!"
          next
        end
      
        if board.move_leaves_king_in_check?(from, to, current_player)
          puts "Invalid move! The king would be in check"
          next
        end
      
        return { from: from, to: to }
      end
    end

    def resolve_turn(from, to)
      opponent = current_player == player_white ? player_black : player_white
      opponent_king_pos = board.find_king(opponent.color)
      opponent_king = board.state[opponent_king_pos[0]][opponent_king_pos[1]]

      if opponent_king.in_checkmate?(opponent_king_pos, board)
        puts "#{opponent} is in checkmate! #{current_player} wins!"
        puts "\n#{board}"
        return true
      elsif opponent_king.in_check?(opponent_king_pos, board)
        puts "#{opponent} is in check!"
      end

      false
    end

    def valid_input?(input)
      input.length == 2 && input.all? { |pos| pos.split(",").length == 2 }
    end
  end
end

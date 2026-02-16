module Chess
  class Game
    SAVED_GAME_PATH = "./data/saved_game.json"

    attr_reader :board, :player_white, :player_black, :current_player

    def initialize
      @board = Board.new
      @player_white = Player.new(:white)
      @player_black = Player.new(:black)
      @current_player = player_white
      @skip_save_prompt = false
    end

    def saved_game
      f = File.new SAVED_GAME_PATH, "w+"
      data = JSON.dump({
        board: board,
        current_player: current_player,
      })
      f.write(data)
      f.close
      puts "Successfully written data to disk."
    end

    def load_game
      data = JSON.load(File.read(SAVED_GAME_PATH))
      @board = data["board"]
      @player_white = Player.new(:white)
      @player_black = Player.new(:black)
      @current_player = data["current_player"] == player_white.to_s ? player_white : player_black
      @skip_save_prompt = true
      puts "Game successfully loaded.\n"
    end

    def play
      puts "Welcome to the game of chess!"
      if File.exist? SAVED_GAME_PATH
        puts "Do you want to load previously saved game? (y/n)" 
        load_game if gets.chomp.downcase == "y"
      end

      loop do
        puts "\n#{board}"
        puts "#{current_player}'s turn"
        puts "Enter move (e.g., '4,6 4,4' for col,row from-to) or 'exit' to quit:"

        input = gets.chomp
        break if input == "exit"
        
        input = input.split
        unless valid_input?(input)
          puts "Invalid input!"
          next
        end

        from = input[0].split(",").map(&:to_i)
        to = input[1].split(",").map(&:to_i)

        # Convert from col,row to row,col for internal use
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

        board.move_piece(from, to)

        opponent = current_player == player_white ? player_black : player_white
        opponent_king_pos = board.find_king(opponent.color)
        opponent_king = board.state[opponent_king_pos[0]][opponent_king_pos[1]]

        if opponent_king.in_checkmate?(opponent_king_pos, board)
          puts "#{opponent} is in checkmate! #{current_player} wins!"
          puts "\n#{board}"
          break
        elsif opponent_king.in_check?(opponent_king_pos, board)
          puts "#{opponent} is in check!"
        end

        self.current_player = opponent

        unless skip_save_prompt
          puts "Do you want to save the game? (y/n)"
          saved_game if gets.chomp.downcase == "y"
        end
      end
    end

    private

    attr_reader :skip_save_prompt
    attr_writer :current_player

    def valid_input?(input)
      input.length == 2 && input.all? { |pos| pos.split(",").length == 2 }
    end
  end
end

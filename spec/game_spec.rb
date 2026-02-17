require_relative "../lib/chess"

describe Chess::Game do
  subject(:game) { described_class.new }

  describe "#initialize" do
    it "creates a board" do
      expect(game.board).to be_a(Chess::Board)
    end

    it "creates white and black players" do
      expect(game.player_white).to be_a(Chess::Player)
      expect(game.player_black).to be_a(Chess::Player)
      expect(game.player_white.color).to eq(:white)
      expect(game.player_black.color).to eq(:black)
    end

    it "initializes game_type as nil" do
      expect(game.game_type).to be_nil
    end
  end

  describe "#play" do
    before do
      allow(File).to receive(:exist?).and_return(false)
    end
    it "calls move_piece on the board when a valid move is made" do
      allow(game).to receive(:gets).and_return("1\n", "4,6 4,4\n", "exit\n")
      allow(game).to receive(:puts)
      allow(game.board).to receive(:valid_move?).and_return(true)

      expect(game.board).to receive(:move_piece).with([6, 4], [4, 4])
      game.play
    end

    it "selects human_vs_human game type when player chooses 1" do
      allow(game).to receive(:gets).and_return("1\n", "exit\n")
      allow(game).to receive(:puts)
      allow(game.board).to receive(:valid_move?).and_return(true)

      game.play
      expect(game.game_type).to eq("human_vs_human")
    end

    it "selects human_vs_computer with player as white when player chooses 2 then y" do
      allow(game).to receive(:gets).and_return("2\n", "y\n", "exit\n")
      allow(game).to receive(:puts)
      allow(game.board).to receive(:valid_move?).and_return(true)

      game.play
      expect(game.game_type).to eq("human_vs_computer")
      expect(game.player_black).to be_a(Chess::ComputerPlayer)
    end
  end

  describe "#save_game and #load_game" do
    let(:save_path) { "./data/saved_game.json" }

    before do
      # Clean up any existing save file
      File.delete(save_path) if File.exist?(save_path)
    end

    after do
      # Clean up after tests
      File.delete(save_path) if File.exist?(save_path)
    end

    it "saves the current player to the game file" do
      game = Chess::Game.new
      allow(game).to receive(:puts)
      game.save_game
      
      data = JSON.load(File.read(save_path))
      expect(data["current_player"]).to eq("White Player")
    end

    it "loads the correct current player from the saved game" do
      allow(game).to receive(:puts)

      game = Chess::Game.new
      allow(game).to receive(:puts)
      # Simulate switching to black player
      game.instance_variable_set(:@current_player, game.player_black)
      game.save_game
      
      new_game = Chess::Game.new
      allow(new_game).to receive(:puts)
      new_game.load_game
      expect(new_game.current_player.to_s).to eq("Black Player")
    end

    it "restores the full game state including board, current player, game_type, and player types" do
      allow(game).to receive(:puts)

      game = Chess::Game.new
      allow(game).to receive(:puts)
      game.board.move_piece([6, 0], [4, 0])
      game.instance_variable_set(:@current_player, game.player_black)
      game.instance_variable_set(:@game_type, "human_vs_computer")
      game.instance_variable_set(:@player_black, Chess::ComputerPlayer.new(:black))
      game.save_game

      new_game = Chess::Game.new
      allow(new_game).to receive(:puts)
      new_game.load_game

      expect(new_game.board.state[4][0]).to be_a(Chess::Pawn)
      expect(new_game.board.state[6][0]).to be_nil
      expect(new_game.current_player.to_s).to eq("Black Player")
      expect(new_game.game_type).to eq("human_vs_computer")
      expect(new_game.player_white).to be_a(Chess::Player)
      expect(new_game.player_white).not_to be_a(Chess::ComputerPlayer)
      expect(new_game.player_black).to be_a(Chess::ComputerPlayer)
    end
  end
end

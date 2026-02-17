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
      allow(game).to receive(:gets).and_return("1\n", "save\n", "exit\n")
      allow(game).to receive(:puts)

      game.play
      
      data = JSON.load(File.read(save_path))
      expect(data["current_player"]).to eq("White Player")
    end

    it "restores the full game state including board, current player, game_type, and player types" do
      allow(game).to receive(:puts)
      allow(game).to receive(:gets).and_return("2\n", "y\n", "save\n", "exit\n")

      game.board.move_piece([6, 0], [4, 0])
      game.play

      new_game = Chess::Game.new
      allow(new_game).to receive(:gets).and_return("1\n")
      allow(new_game).to receive(:puts)
      allow(File).to receive(:exist?).and_call_original

      new_game.send(:load_game) if File.exist?(save_path)

      expect(new_game.board.state[4][0]).to be_a(Chess::Pawn)
      expect(new_game.board.state[6][0]).to be_nil
      expect(new_game.game_type).to eq("human_vs_computer")
      expect(new_game.player_black).to be_a(Chess::ComputerPlayer)
    end
  end
end

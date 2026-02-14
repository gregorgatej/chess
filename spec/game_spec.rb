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
  end

  describe "#play" do
    it "calls move_piece on the board when a valid move is made" do
      allow(game).to receive(:gets).and_return("4,6 4,4\n", "exit\n")
      allow(game).to receive(:puts)
      allow(game.board).to receive(:valid_move?).and_return(true)

      expect(game.board).to receive(:move_piece).with([6, 4], [4, 4])
    
      game.play
    end
  end
end

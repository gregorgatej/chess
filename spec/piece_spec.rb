require_relative "../lib/chess"

describe Chess::Piece do
  describe "#to_s" do
    it "returns correct symbol for white pawn" do
      pawn = Chess::Pawn.new(:white)
      expect(pawn.to_s).to eq("♙")
    end

    it "returns correct symbol for black king" do
      king = Chess::King.new(:black)
      expect(king.to_s).to eq("♚")
    end
  end
end

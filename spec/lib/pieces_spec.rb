require "./pieces.rb"
require "./chess_game.rb"

describe Piece do
    let(:game) { ChessGame.new }

    describe "#initialize" do
        it "knows the game that it's in" do
            piece = Piece.new("White", game)
            expect(piece.instance_variable_get(:@game)).to eq (game)
        end
    end
end
require "./pieces.rb"
require "./chess_game.rb"

describe Pawn do

    let(:game) { ChessGame.new }

    describe "#initialize" do
        it "knows the game that it's in" do
            piece = Piece.new("White", game)
            expect(piece.instance_variable_get(:@game)).to eq (game)
        end
    end

    describe "moving" do
        before :each do
            board = [
                # 0    1    2    3    4    5    6    7
                [nil, nil, nil, nil, nil, nil, nil, nil], #0
                [nil, nil, nil, nil, nil, nil, nil, nil], #1
                [nil, nil, nil, nil, nil, nil, nil, nil], #2
                [nil, nil, nil, nil, nil, nil, nil, nil], #3
                [nil, nil, nil, nil, nil, nil, nil, nil], #4
                [nil, nil, nil, nil, nil, nil, nil, nil], #5
                [nil, nil, nil, nil, nil, nil, nil, nil], #6
                [nil, nil, nil, nil, nil, nil, nil, nil]  #7
            ]
            game.instance_variable_set(:@board, board)
            game.instance_variable_set(:@piece_destination, ["A", "3", nil, 3, 3])
            game.instance_variable_set(:@moved_piece, ["white", nil, "A", "1" , 1, 3])

        end
        describe "#legal_move?" do
            let(:black_pawn) { Pawn.new("Black", game) }
            let(:white_pawn) { Pawn.new("White", game) }
            let(:white_pawn2) { Pawn.new("White", game) }
            
            it "is legal to capture diag." do
                black_pawn.move(5, 3)
                white_pawn.move(6, 2)
                white_pawn2.move(6, 4)
                expect(white_pawn.legal_move?(black_pawn.row, black_pawn.column)).to be true
                expect(white_pawn2.legal_move?(black_pawn.row, black_pawn.column)).to be true
                expect(black_pawn.legal_move?(white_pawn.row, white_pawn.column)).to be true
                expect(black_pawn.legal_move?(white_pawn2.row, white_pawn2.column)).to be true
            end

            it "is illegal to move diag w/o capture" do
                white_pawn.move(6, 2)
                black_pawn.move(1, 0)
                expect(white_pawn.legal_move?(5, 3)).to be false
                expect(black_pawn.legal_move?(black_pawn.row+1,black_pawn.column-1)).to be false
            end

            it "is legal to double move from initial position" do
                black_pawn.move(1, 1)
                white_pawn.move(6, 4)
                expect(white_pawn.legal_move?(white_pawn.row-2, white_pawn.column)).to be true
                expect(black_pawn.legal_move?(black_pawn.row+2, black_pawn.column)).to be true
            end

            it "is illegal to double move from not the initial position" do
                black_pawn.move(2, 2)
                white_pawn.move(3, 3)
                expect(black_pawn.legal_move?(black_pawn.row+2, black_pawn.column)).to be false
                expect(white_pawn.legal_move?(white_pawn.row-2, white_pawn.column)).to be false
            end

            it "is legal to move one square forward if it is empty" do
                white_pawn.move(2, 3)
                black_pawn.move(3, 4)
                expect(black_pawn.legal_move?(black_pawn.row+1, black_pawn.column)).to be true
                expect(white_pawn.legal_move?(white_pawn.row-1, white_pawn.column)).to be true
                
            end
            
            it "is illegal to move one square forward if it is not empty" do
                black_pawn.move(2, 3)
                white_pawn.move(3, 3)
                expect(black_pawn.legal_move?(black_pawn.row+1, black_pawn.column)).to be false
                expect(white_pawn.legal_move?(white_pawn.row-1, white_pawn.column)).to be false
            end

            it "is illegal to move backwards" do
                black_pawn.move(2, 3)
                white_pawn.move(4, 4)
                expect(black_pawn.legal_move?(black_pawn.row-1, black_pawn.column)).to be false
                expect(white_pawn.legal_move?(white_pawn.row+1, white_pawn.column)).to be false

            end

            it "is illegal to move sideways" do
                black_pawn.move(2, 3)
                white_pawn.move(4, 4)
                expect(black_pawn.legal_move?(black_pawn.row, black_pawn.column+1)).to be false
                expect(white_pawn.legal_move?(white_pawn.row, white_pawn.column+1)).to be false
                expect(black_pawn.legal_move?(black_pawn.row, black_pawn.column-1)).to be false
                expect(white_pawn.legal_move?(white_pawn.row, white_pawn.column-1)).to be false

            end
        end

        describe "#enpassante?" do
            let(:black_pawn) { Pawn.new("Black", game) }
            let(:white_pawn) { Pawn.new("White", game) }
            it "returns true if the pawn is allowed to enpassante an enemy pawn" do
                white_pawn.move(3, 2)
                black_pawn.move(3, 3)
                game.instance_variable_set(:@moved_piece, ["white", black_pawn.class, "A", "1" , 1, 3])
                game.instance_variable_set(:@piece_destination, ["A", "3", nil, 3, 3])
                expect(white_pawn.is_enpassante?(2, 3)).to be true
            end

            it "returns true if the pawn is allowed to enpassante an enemy pawn" do
                black_pawn.move(4, 2)
                white_pawn.move(4, 1)
                game.instance_variable_set(:@moved_piece, ["black", white_pawn.class, "A", "1" , 6, 1])
                game.instance_variable_set(:@piece_destination, ["A", "3", nil, 4, 1])
                expect(black_pawn.is_enpassante?(5, 1)).to be true
            end
        end
    end
end
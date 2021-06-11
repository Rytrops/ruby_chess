require "./pieces.rb"
require "./chess_game.rb"

describe Queen do

    let(:game) { ChessGame.new }

    describe "moving" do
        describe "#legal_move?" do
            let(:black_pawn) { Pawn.new("Black", game) }
            let(:white_pawn) { Pawn.new("White", game) }
            let(:black_pawn2) { Pawn.new("Black", game) }
            let(:white_pawn2) { Pawn.new("White", game) }
            let(:black_queen) { Queen.new("Black", game) }
            let(:white_queen) { Queen.new("White", game) }
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

            it "is legal to move one square in the same row to capture enemy piece" do
                white_queen.move(6, 3)
                black_pawn.move(6, 2)
                expect(white_queen.legal_move?(black_pawn.row, black_pawn.column)).to be true
                black_pawn.move(6, 4)
                expect(white_queen.legal_move?(black_pawn.row, black_pawn.column)).to be true
                black_queen.move(2, 2)
                white_pawn.move(2, 3)
                expect(black_queen.legal_move?(white_pawn.row, white_pawn.column)).to be true
                white_pawn.move(2, 1)
                expect(black_queen.legal_move?(white_pawn.row, white_pawn.column)).to be true
            end

            it "is legal to move one square in the same column to capture enemy piece" do
                white_queen.move(6, 3)
                black_pawn.move(5, 3)
                expect(white_queen.legal_move?(black_pawn.row, black_pawn.column)).to be true
                black_pawn.move(4, 3)
                expect(white_queen.legal_move?(black_pawn.row, black_pawn.column)).to be true
                black_queen.move(2, 2)
                white_pawn.move(1, 2)
                expect(black_queen.legal_move?(white_pawn.row, white_pawn.column)).to be true
                white_pawn.move(3, 2)
                expect(black_queen.legal_move?(white_pawn.row, white_pawn.column)).to be true
            end

            it "is legal to move more than one square in the same column to capture enemy piece" do
                white_queen.move(5, 3)
                black_pawn.move(2, 3)
                expect(white_queen.legal_move?(black_pawn.row, black_pawn.column)).to be true
                black_pawn.move(7, 3)
                expect(white_queen.legal_move?(black_pawn.row, black_pawn.column)).to be true
                black_queen.move(2, 2)
                white_pawn.move(0, 2)
                expect(black_queen.legal_move?(white_pawn.row, white_pawn.column)).to be true
                white_pawn.move(5, 2)
                expect(black_queen.legal_move?(white_pawn.row, white_pawn.column)).to be true
            end

            it "is legal to move more than one square in the same row to capture enemy piece" do
                white_queen.move(6, 3)
                black_pawn.move(6, 0)
                expect(white_queen.legal_move?(black_pawn.row, black_pawn.column)).to be true
                black_pawn.move(6, 7)
                expect(white_queen.legal_move?(black_pawn.row, black_pawn.column)).to be true
                black_queen.move(2, 2)
                white_pawn.move(2, 0)
                expect(black_queen.legal_move?(white_pawn.row, white_pawn.column)).to be true
                white_pawn.move(2, 5)
                expect(black_queen.legal_move?(white_pawn.row, white_pawn.column)).to be true
            end

            it "is legal to move one square in the same column to empty square" do
                white_queen.move(6, 3)
                expect(white_queen.legal_move?(5, 3)).to be true
                expect(white_queen.legal_move?(4, 3)).to be true
                black_queen.move(2, 2)
                expect(black_queen.legal_move?(1, 2)).to be true
                expect(black_queen.legal_move?(3, 2)).to be true
            end

            it "is legal to move one square in the same row to empty square" do
                white_queen.move(6, 3)
                expect(white_queen.legal_move?(6, 2)).to be true
                expect(white_queen.legal_move?(6, 4)).to be true
                black_queen.move(2, 2)
                expect(black_queen.legal_move?(2, 3)).to be true
                expect(black_queen.legal_move?(2, 1)).to be true
            end

            it "is legal to move more than one square in the same column to empty square" do
                white_queen.move(5, 3)
                expect(white_queen.legal_move?(7, 3)).to be true
                expect(white_queen.legal_move?(2, 3)).to be true
                black_queen.move(2, 2)
                expect(black_queen.legal_move?(0, 2)).to be true
                expect(black_queen.legal_move?(5, 2)).to be true
            end

            it "is legal to move more than one square in the same row to empty square" do
                white_queen.move(6, 3)
                expect(white_queen.legal_move?(6, 5)).to be true
                expect(white_queen.legal_move?(6, 0)).to be true
                black_queen.move(2, 2)
                expect(black_queen.legal_move?(2, 0)).to be true
                expect(black_queen.legal_move?(2, 5)).to be true
            end

            it "is illegal to move to a sqaure occupied by a piece from same team" do
                white_queen.move(6, 3)
                white_pawn.move(6, 2)
                expect(white_queen.legal_move?(white_pawn.row, white_pawn.column)).to be false
                white_pawn.move(6, 4)
                expect(white_queen.legal_move?(white_pawn.row, white_pawn.column)).to be false
                black_queen.move(2, 2)
                black_pawn.move(2, 3)
                expect(black_queen.legal_move?(black_pawn.row, black_pawn.column)).to be false
                black_pawn.move(2, 1)
                expect(black_queen.legal_move?(black_pawn.row, black_pawn.column)).to be false
            end

            it "is illegal to move through an occupied square to reach destination" do
                white_queen.move(6, 3)
                white_pawn.move(6, 4)
                expect(white_queen.legal_move?(6, 5)).to be false
                black_pawn.move(6, 1)
                expect(white_queen.legal_move?(6, 0)).to be false
                white_pawn.move(2, 3)
                expect(white_queen.legal_move?(0, 3)).to be false
                white_queen.move(5, 3)
                white_pawn.move(6, 3)
                expect(white_queen.legal_move?(7, 3)).to be false
                black_queen.move(2, 2)
                black_pawn.move(2, 1)
                expect(black_queen.legal_move?(2, 0)).to be false
                black_pawn.move(2, 4)
                expect(black_queen.legal_move?(2, 5)).to be false
                black_pawn.move(4, 2)
                expect(black_queen.legal_move?(5, 2)).to be false
                black_pawn.move(1, 2)
                expect(black_queen.legal_move?(0, 2)).to be false
            end

            it "is legal to move one square diagonally to capture an enemy piece" do
                black_queen.move(4,4)
                white_pawn.move(3,3)
                expect(black_queen.legal_move?(white_pawn.row, white_pawn.column)).to be true
                white_pawn.move(3,5)
                expect(black_queen.legal_move?(white_pawn.row, white_pawn.column)).to be true
                white_pawn.move(5,3)
                expect(black_queen.legal_move?(white_pawn.row, white_pawn.column)).to be true
                white_pawn.move(5,5)
                expect(black_queen.legal_move?(white_pawn.row, white_pawn.column)).to be true
                white_queen.move(4, 4)
                black_pawn.move(3,3)
                expect(white_queen.legal_move?(black_pawn.row, black_pawn.column)).to be true
                black_pawn.move(3,5)
                expect(white_queen.legal_move?(black_pawn.row, black_pawn.column)).to be true
                black_pawn.move(5,3)
                expect(white_queen.legal_move?(black_pawn.row, black_pawn.column)).to be true
                black_pawn.move(5,5)
                expect(white_queen.legal_move?(black_pawn.row, black_pawn.column)).to be true
            end

            it "is legal to move more than one square diagonally to capture enemy piece if no other pieces are in the way" do
                black_queen.move(4,4)
                white_pawn.move(0,0)
                expect(black_queen.legal_move?(white_pawn.row, white_pawn.column)).to be true
                white_pawn.move(1,7)
                expect(black_queen.legal_move?(white_pawn.row, white_pawn.column)).to be true
                white_pawn.move(7,1)
                expect(black_queen.legal_move?(white_pawn.row, white_pawn.column)).to be true
                white_pawn.move(7,7)
                expect(black_queen.legal_move?(white_pawn.row, white_pawn.column)).to be true
                white_queen.move(4, 4)
                black_pawn.move(0,0)
                expect(white_queen.legal_move?(black_pawn.row, black_pawn.column)).to be true
                black_pawn.move(1, 7)
                expect(white_queen.legal_move?(black_pawn.row, black_pawn.column)).to be true
                black_pawn.move(7, 1)
                expect(white_queen.legal_move?(black_pawn.row, black_pawn.column)).to be true
                black_pawn.move(7, 7)
                expect(white_queen.legal_move?(black_pawn.row, black_pawn.column)).to be true
            end
            it "is legal to move one square diagonally to empty square" do
                black_queen.move(4,4)
                expect(black_queen.legal_move?(3, 3)).to be true
                expect(black_queen.legal_move?(3, 5)).to be true
                expect(black_queen.legal_move?(5, 3)).to be true
                expect(black_queen.legal_move?(5, 5)).to be true
                white_queen.move(4, 4)
                expect(white_queen.legal_move?(3, 3)).to be true
                expect(white_queen.legal_move?(3, 5)).to be true
                expect(white_queen.legal_move?(5, 3)).to be true
                expect(white_queen.legal_move?(5, 5)).to be true
            end

            it "is illegal to move onto friendly piece" do
                black_queen.move(4,4)
                black_pawn.move(3,3)
                expect(black_queen.legal_move?(black_pawn.row, black_pawn.column)).to be false
                black_pawn.move(3,5)
                expect(black_queen.legal_move?(black_pawn.row, black_pawn.column)).to be false
                black_pawn.move(5,3)
                expect(black_queen.legal_move?(black_pawn.row, black_pawn.column)).to be false
                black_pawn.move(5,5)
                expect(black_queen.legal_move?(black_pawn.row, black_pawn.column)).to be false
                black_pawn.move(0,0)
                expect(black_queen.legal_move?(black_pawn.row, black_pawn.column)).to be false
                black_pawn.move(1,7)
                expect(black_queen.legal_move?(black_pawn.row, black_pawn.column)).to be false
                black_pawn.move(7,1)
                expect(black_queen.legal_move?(black_pawn.row, black_pawn.column)).to be false
                black_pawn.move(7,7)
                expect(black_queen.legal_move?(black_pawn.row, black_pawn.column)).to be false
                white_queen.move(4, 4)
                white_pawn.move(3,3)
                expect(white_queen.legal_move?(white_pawn.row, white_pawn.column)).to be false
                white_pawn.move(3,5)
                expect(white_queen.legal_move?(white_pawn.row, white_pawn.column)).to be false
                white_pawn.move(5,3)
                expect(white_queen.legal_move?(white_pawn.row, white_pawn.column)).to be false
                white_pawn.move(5,5)
                expect(white_queen.legal_move?(white_pawn.row, white_pawn.column)).to be false
                white_pawn.move(0,0)
                expect(white_queen.legal_move?(white_pawn.row, white_pawn.column)).to be false
                white_pawn.move(1,7)
                expect(white_queen.legal_move?(white_pawn.row, white_pawn.column)).to be false
                white_pawn.move(7,1)
                expect(white_queen.legal_move?(white_pawn.row, white_pawn.column)).to be false
                white_pawn.move(7,7)
                expect(white_queen.legal_move?(white_pawn.row, white_pawn.column)).to be false
                white_pawn.move(0,0)
                expect(white_queen.legal_move?(white_pawn.row, white_pawn.column)).to be false
                white_pawn.move(1, 7)
                expect(white_queen.legal_move?(white_pawn.row, white_pawn.column)).to be false
                white_pawn.move(7, 1)
                expect(white_queen.legal_move?(white_pawn.row, white_pawn.column)).to be false
                white_pawn.move(7, 7)
                expect(white_queen.legal_move?(white_pawn.row, white_pawn.column)).to be false
            end
            
            it "is illegal to move through another piece" do 
                black_queen.move(4,4)
                white_pawn.move(0,0)
                black_pawn2.move(3,3)
                expect(black_queen.legal_move?(white_pawn.row, white_pawn.column)).to be false
                white_pawn.move(1,7)
                black_pawn2.move(3,5)
                expect(black_queen.legal_move?(white_pawn.row, white_pawn.column)).to be false
                white_pawn.move(7,1)
                white_pawn2.move(5,3)
                expect(black_queen.legal_move?(white_pawn.row, white_pawn.column)).to be false
                white_pawn.move(7,7)
                white_pawn2.move(5,5)
                expect(black_queen.legal_move?(white_pawn.row, white_pawn.column)).to be false
                white_queen.move(4, 4)
                black_pawn.move(0,0)
                white_pawn2.move(3,3)
                expect(white_queen.legal_move?(black_pawn.row, black_pawn.column)).to be false
                black_pawn.move(1, 7)
                white_pawn2.move(3,5)
                expect(white_queen.legal_move?(black_pawn.row, black_pawn.column)).to be false
                black_pawn.move(7, 1)
                black_pawn2.move(5,3)
                expect(white_queen.legal_move?(black_pawn.row, black_pawn.column)).to be false
                black_pawn.move(7, 7)
                black_pawn2.move(5,5)
                expect(white_queen.legal_move?(black_pawn.row, black_pawn.column)).to be false
            end
        end
    end
end
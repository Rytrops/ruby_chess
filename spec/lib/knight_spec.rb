require "./pieces.rb"
require "./chess_game.rb"

describe Knight do

    let(:game) { ChessGame.new }

    describe "moving" do
        describe "#legal_move?" do
            let(:black_pawn) { Pawn.new("Black", game) }
            let(:white_pawn) { Pawn.new("White", game) }
            let(:black_knight) { Knight.new("Black", game) }
            let(:white_knight) { Knight.new("White", game) }
            let(:white_knight2) { Knight.new("White", game) }
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
            end

            it "is legal to move 2 rows and one column to capture enemy piece" do
                black_knight.move(1, 2)
                white_knight.move(6, 5)
                white_pawn.move(3, 1)
                black_pawn.move(4, 4)
                expect(black_knight.legal_move?(white_pawn.row, white_pawn.column)).to be true
                expect(white_knight.legal_move?(black_pawn.row, black_pawn.column)).to be true
                white_pawn.move(3, 3)
                black_pawn.move(4, 6)
                expect(black_knight.legal_move?(white_pawn.row, white_pawn.column)).to be true
                expect(white_knight.legal_move?(black_pawn.row, black_pawn.column)).to be true
                black_knight.move(3, 3)
                white_knight.move(5, 4)
                white_pawn.move(1, 2)
                black_pawn.move(7, 3)
                expect(black_knight.legal_move?(white_pawn.row, white_pawn.column)).to be true
                expect(white_knight.legal_move?(black_pawn.row, black_pawn.column)).to be true
                white_pawn.move(1, 4)
                black_pawn.move(7, 5)
                expect(black_knight.legal_move?(white_pawn.row, white_pawn.column)).to be true
                expect(white_knight.legal_move?(black_pawn.row, black_pawn.column)).to be true
            end
            it "is legal to move 2 rows and one column to empty square" do
                black_knight.move(1, 2)
                white_knight.move(6, 5)
                expect(black_knight.legal_move?(3, 1)).to be true
                expect(white_knight.legal_move?(4, 4)).to be true
                expect(black_knight.legal_move?(3, 1)).to be true
                expect(white_knight.legal_move?(4, 4)).to be true
                black_knight.move(3, 3)
                white_knight.move(5, 4)
                expect(black_knight.legal_move?(1, 2)).to be true
                expect(white_knight.legal_move?(7, 3)).to be true
                expect(black_knight.legal_move?(1, 4)).to be true
                expect(white_knight.legal_move?(7, 5)).to be true
            end

            it "is illegal to move 2 rows and one column to square occupied by same team" do
                black_knight.move(1, 2)
                white_knight.move(6, 5)
                black_pawn.move(3, 1)
                white_pawn.move(4, 4)
                expect(black_knight.legal_move?(black_pawn.row, black_pawn.column)).to be false
                expect(white_knight.legal_move?(white_pawn.row, white_pawn.column)).to be false
                black_pawn.move(3, 3)
                white_pawn.move(4, 6)
                expect(black_knight.legal_move?(black_pawn.row, black_pawn.column)).to be false
                expect(white_knight.legal_move?(white_pawn.row, white_pawn.column)).to be false
                black_knight.move(3, 3)
                white_knight.move(5, 4)
                black_pawn.move(1, 2)
                white_pawn.move(7, 3)
                expect(black_knight.legal_move?(black_pawn.row, black_pawn.column)).to be false
                expect(white_knight.legal_move?(white_pawn.row, white_pawn.column)).to be false
                black_pawn.move(1, 4)
                white_pawn.move(7, 5)
                expect(black_knight.legal_move?(black_pawn.row, black_pawn.column)).to be false
                expect(white_knight.legal_move?(white_pawn.row, white_pawn.column)).to be false
            end

            it "is legal to move 1 row and 2 columns to capture enemy piece" do
                black_knight.move(1, 2)
                white_knight.move(6, 5)
                white_pawn.move(2, 4)
                black_pawn.move(5, 7)
                expect(black_knight.legal_move?(white_pawn.row, white_pawn.column)).to be true
                expect(white_knight.legal_move?(black_pawn.row, black_pawn.column)).to be true
                white_pawn.move(2, 0)
                black_pawn.move(5, 3)
                expect(black_knight.legal_move?(white_pawn.row, white_pawn.column)).to be true
                expect(white_knight.legal_move?(black_pawn.row, black_pawn.column)).to be true
                white_pawn.move(0, 0)
                black_pawn.move(7, 7)
                expect(black_knight.legal_move?(white_pawn.row, white_pawn.column)).to be true
                expect(white_knight.legal_move?(black_pawn.row, black_pawn.column)).to be true
                white_pawn.move(0, 4)
                black_pawn.move(7, 3)
                expect(black_knight.legal_move?(white_pawn.row, white_pawn.column)).to be true
                expect(white_knight.legal_move?(black_pawn.row, black_pawn.column)).to be true
            end

            it "is legal to move 1 row and 2 columns to empty square" do 
                black_knight.move(1, 2)
                white_knight.move(6, 5)
                expect(black_knight.legal_move?(3, 1)).to be true
                expect(white_knight.legal_move?(4, 4)).to be true
                expect(black_knight.legal_move?(3, 3)).to be true
                expect(white_knight.legal_move?(4, 6)).to be true
                expect(black_knight.legal_move?(0, 0)).to be true
                expect(white_knight.legal_move?(7, 7)).to be true
                expect(black_knight.legal_move?(0, 4)).to be true
                expect(white_knight.legal_move?(7, 3)).to be true
            end

            it "is illegal to move 1 row and 2 columns to occupied square of same team" do 
                black_knight.move(1, 2)
                white_knight.move(6, 5)
                black_pawn.move(2, 4)
                white_pawn.move(5, 7)
                expect(black_knight.legal_move?(black_pawn.row, black_pawn.column)).to be false
                expect(white_knight.legal_move?(white_pawn.row, white_pawn.column)).to be false
                black_pawn.move(2, 0)
                white_pawn.move(5, 3)
                expect(black_knight.legal_move?(black_pawn.row, black_pawn.column)).to be false
                expect(white_knight.legal_move?(white_pawn.row, white_pawn.column)).to be false
                black_pawn.move(0, 0)
                white_pawn.move(7, 7)
                expect(black_knight.legal_move?(black_pawn.row, black_pawn.column)).to be false
                expect(white_knight.legal_move?(white_pawn.row, white_pawn.column)).to be false
                black_pawn.move(0, 4)
                white_pawn.move(7, 3)
                expect(black_knight.legal_move?(black_pawn.row, black_pawn.column)).to be false
                expect(white_knight.legal_move?(white_pawn.row, white_pawn.column)).to be false
            end
        end
    end
end
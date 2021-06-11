require "./pieces.rb"
require "./chess_game.rb"

describe Bishop do

    let(:game) { ChessGame.new }

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
        end
        describe "#legal_move?" do
            let(:black_pawn) { Pawn.new("Black", game) }
            let(:white_pawn) { Pawn.new("White", game) }
            let(:black_bishop) { Bishop.new("Black", game) }
            let(:white_bishop) { Bishop.new("White", game) }
            let(:black_pawn2) { Queen.new("Black", game) }
            let(:white_pawn2) { Queen.new("White", game) }
            let(:black_bishop) { Bishop.new("Black", game) }
            let(:white_king) { King.new("White", game) }
            let(:white_rook) { Rook.new("White", game) }
            # let(:white_knight2) { Knight.new("White", game) }
           

            it "is legal to move one square diagonally to capture an enemy piece" do
                black_bishop.move(4,4)
                white_pawn.move(3,3)
                expect(black_bishop.legal_move?(white_pawn.row, white_pawn.column)).to be true
                white_pawn.move(3,5)
                expect(black_bishop.legal_move?(white_pawn.row, white_pawn.column)).to be true
                white_pawn.move(5,3)
                expect(black_bishop.legal_move?(white_pawn.row, white_pawn.column)).to be true
                white_pawn.move(5,5)
                expect(black_bishop.legal_move?(white_pawn.row, white_pawn.column)).to be true
                white_bishop.move(4, 4)
                black_pawn.move(3,3)
                expect(white_bishop.legal_move?(black_pawn.row, black_pawn.column)).to be true
                black_pawn.move(3,5)
                expect(white_bishop.legal_move?(black_pawn.row, black_pawn.column)).to be true
                black_pawn.move(5,3)
                expect(white_bishop.legal_move?(black_pawn.row, black_pawn.column)).to be true
                black_pawn.move(5,5)
                expect(white_bishop.legal_move?(black_pawn.row, black_pawn.column)).to be true
            end

            it "is legal to move more than one square diagonally to capture enemy piece if no other pieces are in the way" do
                black_bishop.move(4,4)
                white_pawn.move(0,0)
                expect(black_bishop.legal_move?(white_pawn.row, white_pawn.column)).to be true
                white_pawn.move(1,7)
                expect(black_bishop.legal_move?(white_pawn.row, white_pawn.column)).to be true
                white_pawn.move(7,1)
                expect(black_bishop.legal_move?(white_pawn.row, white_pawn.column)).to be true
                white_pawn.move(7,7)
                expect(black_bishop.legal_move?(white_pawn.row, white_pawn.column)).to be true
                white_bishop.move(4, 4)
                black_pawn.move(0,0)
                expect(white_bishop.legal_move?(black_pawn.row, black_pawn.column)).to be true
                black_pawn.move(1, 7)
                expect(white_bishop.legal_move?(black_pawn.row, black_pawn.column)).to be true
                black_pawn.move(7, 1)
                expect(white_bishop.legal_move?(black_pawn.row, black_pawn.column)).to be true
                black_pawn.move(7, 7)
                expect(white_bishop.legal_move?(black_pawn.row, black_pawn.column)).to be true
            end

            it "is legal to move one square diagonally to empty square" do
                    black_bishop.move(4,4)
                    expect(black_bishop.legal_move?(3, 3)).to be true
                    expect(black_bishop.legal_move?(3, 5)).to be true
                    expect(black_bishop.legal_move?(5, 3)).to be true
                    expect(black_bishop.legal_move?(5, 5)).to be true
                    white_bishop.move(4, 4)
                    expect(white_bishop.legal_move?(3, 3)).to be true
                    expect(white_bishop.legal_move?(3, 5)).to be true
                    expect(white_bishop.legal_move?(5, 3)).to be true
                    expect(white_bishop.legal_move?(5, 5)).to be true
            end

            it "is illegal to move onto friendly piece" do
                black_bishop.move(4,4)
                black_pawn.move(3,3)
                expect(black_bishop.legal_move?(black_pawn.row, black_pawn.column)).to be false
                black_pawn.move(3,5)
                expect(black_bishop.legal_move?(black_pawn.row, black_pawn.column)).to be false
                black_pawn.move(5,3)
                expect(black_bishop.legal_move?(black_pawn.row, black_pawn.column)).to be false
                black_pawn.move(5,5)
                expect(black_bishop.legal_move?(black_pawn.row, black_pawn.column)).to be false
                black_pawn.move(0,0)
                expect(black_bishop.legal_move?(black_pawn.row, black_pawn.column)).to be false
                black_pawn.move(1,7)
                expect(black_bishop.legal_move?(black_pawn.row, black_pawn.column)).to be false
                black_pawn.move(7,1)
                expect(black_bishop.legal_move?(black_pawn.row, black_pawn.column)).to be false
                black_pawn.move(7,7)
                expect(black_bishop.legal_move?(black_pawn.row, black_pawn.column)).to be false
                white_bishop.move(4, 4)
                white_pawn.move(3,3)
                expect(white_bishop.legal_move?(white_pawn.row, white_pawn.column)).to be false
                white_pawn.move(3,5)
                expect(white_bishop.legal_move?(white_pawn.row, white_pawn.column)).to be false
                white_pawn.move(5,3)
                expect(white_bishop.legal_move?(white_pawn.row, white_pawn.column)).to be false
                white_pawn.move(5,5)
                expect(white_bishop.legal_move?(white_pawn.row, white_pawn.column)).to be false
                white_pawn.move(0,0)
                expect(white_bishop.legal_move?(white_pawn.row, white_pawn.column)).to be false
                white_pawn.move(1,7)
                expect(white_bishop.legal_move?(white_pawn.row, white_pawn.column)).to be false
                white_pawn.move(7,1)
                expect(white_bishop.legal_move?(white_pawn.row, white_pawn.column)).to be false
                white_pawn.move(7,7)
                expect(white_bishop.legal_move?(white_pawn.row, white_pawn.column)).to be false
                white_pawn.move(0,0)
                expect(white_bishop.legal_move?(white_pawn.row, white_pawn.column)).to be false
                white_pawn.move(1, 7)
                expect(white_bishop.legal_move?(white_pawn.row, white_pawn.column)).to be false
                white_pawn.move(7, 1)
                expect(white_bishop.legal_move?(white_pawn.row, white_pawn.column)).to be false
                white_pawn.move(7, 7)
                expect(white_bishop.legal_move?(white_pawn.row, white_pawn.column)).to be false
            end
            
            it "is illegal to move through another piece" do 
                black_bishop.move(4,4)
                white_pawn.move(0,0)
                black_pawn2.move(3,3)
                expect(black_bishop.legal_move?(white_pawn.row, white_pawn.column)).to be false
                white_pawn.move(1,7)
                black_pawn2.move(3,5)
                expect(black_bishop.legal_move?(white_pawn.row, white_pawn.column)).to be false
                white_pawn.move(7,1)
                white_pawn2.move(5,3)
                expect(black_bishop.legal_move?(white_pawn.row, white_pawn.column)).to be false
                white_pawn.move(7,7)
                white_pawn2.move(5,5)
                expect(black_bishop.legal_move?(white_pawn.row, white_pawn.column)).to be false
                white_bishop.move(4, 4)
                black_pawn.move(0,0)
                white_pawn2.move(3,3)
                expect(white_bishop.legal_move?(black_pawn.row, black_pawn.column)).to be false
                black_pawn.move(1, 7)
                white_pawn2.move(3,5)
                expect(white_bishop.legal_move?(black_pawn.row, black_pawn.column)).to be false
                black_pawn.move(7, 1)
                black_pawn2.move(5,3)
                expect(white_bishop.legal_move?(black_pawn.row, black_pawn.column)).to be false
                black_pawn.move(7, 7)
                black_pawn2.move(5,5)
                expect(white_bishop.legal_move?(black_pawn.row, black_pawn.column)).to be false
            end

            it "is illegal to not move diagonally" do
            white_king.move(5, 4)
            black_bishop.move(1, 0)
            white_rook.move(3, 4)
            expect(black_bishop.legal_move?(2, 6)).to be false
            end
        end

        describe "#available_moves" do
            let(:black_bishop) { Bishop.new("Black", game) }

            it "returns an array of all available moves" do
                black_bishop.move(0, 1)
                
                expect(black_bishop.available_moves).to be_a Array
            end
        end

        describe "#squares_to_king" do
            let(:black_bishop) { Bishop.new("Black", game) }
            let(:white_king) { King.new("White", game) }

            it "returns an array of all squares between itself and the enemy king." do
                black_bishop.move(0, 1)
                white_king.move(4, 4)
                expect(black_bishop.squares_to_king.length).to eq 3
                black_bishop.move(0, 0)
                white_king.move(4, 4)
                expect(game.moves_to_clear_check).to be_a Array
            end
        end

        describe "#can_clear_check?" do
            it "returns true if the piece can clear check" do
            
            
            end
        end
    end
end
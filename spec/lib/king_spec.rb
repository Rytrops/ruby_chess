require "./pieces.rb"
require "./chess_game.rb"

describe King do

    let(:game) { ChessGame.new }

    describe "#in_check?" do
        
        let(:black_pawn) { Pawn.new("Black", game) }
        let(:white_pawn) { Pawn.new("White", game) }
        let(:white_king) { King.new("White", game) }
        let(:black_king) { King.new("Black", game) }
        let(:black_bishop) { Bishop.new("Black", game) }
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
        
        it "returns true if the king is in check" do
            white_king.move(4, 4)
            black_pawn.move(3, 3)
            black_bishop.move(1, 7)
            expect(white_king.in_check?).to be true
        end

        it "returns false if the king is not in check" do
            white_king.move(4, 4)
            white_pawn.move(3,3)
            expect(white_king.in_check?).to be false
        end
    end

    describe "#legal_move?" do
            let(:black_pawn) { Pawn.new("Black", game) }
            let(:white_pawn) { Pawn.new("White", game) }
            let(:black_king) { King.new("Black", game) }
            let(:white_king) { King.new("White", game) }
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
        it "is legal to move to any adjacent square to capture enemy piece" do
            black_king.move(5, 1)
            white_pawn.move(4, 0)
            expect(black_king.legal_move?(white_pawn.row, white_pawn.column)).to be true
            white_pawn.move(4, 1)
            expect(black_king.legal_move?(white_pawn.row, white_pawn.column)).to be true
            white_pawn.move(4, 2)
            expect(black_king.legal_move?(white_pawn.row, white_pawn.column)).to be true
            white_pawn.move(5, 0)
            expect(black_king.legal_move?(white_pawn.row, white_pawn.column)).to be true
            white_pawn.move(5, 2)
            expect(black_king.legal_move?(white_pawn.row, white_pawn.column)).to be true
            white_pawn.move(6, 0)
            expect(black_king.legal_move?(white_pawn.row, white_pawn.column)).to be true
            white_pawn.move(6, 1)
            expect(black_king.legal_move?(white_pawn.row, white_pawn.column)).to be true
            white_pawn.move(6, 2)
            expect(black_king.legal_move?(white_pawn.row, white_pawn.column)).to be true
            white_king.move(3, 1)
            black_pawn.move(2, 0)
            expect(white_king.legal_move?(black_pawn.row, black_pawn.column)).to be true
            black_pawn.move(2, 1)
            expect(white_king.legal_move?(black_pawn.row, black_pawn.column)).to be true
            black_pawn.move(2, 2)
            expect(white_king.legal_move?(black_pawn.row, black_pawn.column)).to be true
            black_pawn.move(3, 0)
            expect(white_king.legal_move?(black_pawn.row, black_pawn.column)).to be true
            black_pawn.move(3, 2)
            expect(white_king.legal_move?(black_pawn.row, black_pawn.column)).to be true
        end

        it "is legal to move to adjacent square if unoccupied" do
            white_king.move(5, 1)
            expect(white_king.legal_move?(4, 0)).to be true
            expect(white_king.legal_move?(4, 1)).to be true
            expect(white_king.legal_move?(4, 2)).to be true
            expect(white_king.legal_move?(5, 0)).to be true
            expect(white_king.legal_move?(5, 2)).to be true
            expect(white_king.legal_move?(6, 0)).to be true
            expect(white_king.legal_move?(6, 1)).to be true
            black_king.move(3, 1)
            expect(black_king.legal_move?(2, 0)).to be true
            expect(black_king.legal_move?(2, 1)).to be true
            expect(black_king.legal_move?(2, 2)).to be true
            expect(black_king.legal_move?(3, 0)).to be true
            expect(black_king.legal_move?(3, 2)).to be true
         end

         it "is legal to move to any adjacent square if unoccupied" do
            black_king.move(5, 1)
            white_pawn.move(4, 0)
            expect(black_king.legal_move?(white_pawn.row, white_pawn.column)).to be true
            white_pawn.move(4, 1)
            expect(black_king.legal_move?(white_pawn.row, white_pawn.column)).to be true
            white_pawn.move(4, 2)
            expect(black_king.legal_move?(white_pawn.row, white_pawn.column)).to be true
            white_pawn.move(5, 0)
            expect(black_king.legal_move?(white_pawn.row, white_pawn.column)).to be true
            white_pawn.move(5, 2)
            expect(black_king.legal_move?(white_pawn.row, white_pawn.column)).to be true
            white_pawn.move(6, 0)
            expect(black_king.legal_move?(white_pawn.row, white_pawn.column)).to be true
            white_pawn.move(6, 1)
            expect(black_king.legal_move?(white_pawn.row, white_pawn.column)).to be true
            white_pawn.move(6, 2)
            expect(black_king.legal_move?(white_pawn.row, white_pawn.column)).to be true
            white_king.move(3, 1)
            black_pawn.move(2, 0)
            expect(white_king.legal_move?(black_pawn.row, black_pawn.column)).to be true
            black_pawn.move(2, 1)
            expect(white_king.legal_move?(black_pawn.row, black_pawn.column)).to be true
            black_pawn.move(2, 2)
            expect(white_king.legal_move?(black_pawn.row, black_pawn.column)).to be true
            black_pawn.move(3, 0)
            expect(white_king.legal_move?(black_pawn.row, black_pawn.column)).to be true
            black_pawn.move(3, 2)
            expect(white_king.legal_move?(black_pawn.row, black_pawn.column)).to be true
        end

        it "is illegal to move to any adjacent square if occupied by same team" do
            black_king.move(5, 1)
            black_pawn.move(4, 0)
            expect(black_king.legal_move?(black_pawn.row, black_pawn.column)).to be false
            black_pawn.move(4, 1)
            expect(black_king.legal_move?(black_pawn.row, black_pawn.column)).to be false
            black_pawn.move(4, 2)
            expect(black_king.legal_move?(black_pawn.row, black_pawn.column)).to be false
            black_pawn.move(5, 0)
            expect(black_king.legal_move?(black_pawn.row, black_pawn.column)).to be false
            black_pawn.move(5, 2)
            expect(black_king.legal_move?(black_pawn.row, black_pawn.column)).to be false
            black_pawn.move(6, 0)
            expect(black_king.legal_move?(black_pawn.row, black_pawn.column)).to be false
            black_pawn.move(6, 1)
            expect(black_king.legal_move?(black_pawn.row, black_pawn.column)).to be false
            black_pawn.move(6, 2)
            expect(black_king.legal_move?(black_pawn.row, black_pawn.column)).to be false
            white_king.move(3, 1)
            white_pawn.move(2, 0)
            expect(white_king.legal_move?(white_pawn.row, white_pawn.column)).to be false
            white_pawn.move(2, 1)
            expect(white_king.legal_move?(white_pawn.row, white_pawn.column)).to be false
            white_pawn.move(2, 2)
            expect(white_king.legal_move?(white_pawn.row, white_pawn.column)).to be false
            white_pawn.move(3, 0)
            expect(white_king.legal_move?(white_pawn.row, white_pawn.column)).to be false
            white_pawn.move(3, 2)
            expect(white_king.legal_move?(white_pawn.row, white_pawn.column)).to be false
            white_pawn.move(4, 0)
            expect(white_king.legal_move?(white_pawn.row, white_pawn.column)).to be false
            white_pawn.move(4, 1)
            expect(white_king.legal_move?(white_pawn.row, white_pawn.column)).to be false
            white_pawn.move(4, 2)
            expect(white_king.legal_move?(white_pawn.row, white_pawn.column)).to be false
        end
    end

    describe "#destination_adjacent_to_enemy_king?" do
        let(:black_king) { King.new("Black", game) }
        let(:white_king) { King.new("White", game) }

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

        it "is illegal for one king to move adjacent to another king " do
            black_king.move(5, 3)
            white_king.move(5, 1)
            expect(white_king.destination_adjacent_to_enemy_king?(4, 2, black_king)).to be true
            expect(white_king.destination_adjacent_to_enemy_king?(5, 2, black_king)).to be true
            expect(white_king.destination_adjacent_to_enemy_king?(6, 2, black_king)).to be true
            black_king.move(7, 1)
            expect(white_king.destination_adjacent_to_enemy_king?(6, 0, black_king)).to be true
            expect(white_king.destination_adjacent_to_enemy_king?(6, 1, black_king)).to be true
            expect(white_king.destination_adjacent_to_enemy_king?(6, 2, black_king)).to be true
        end
    end

    describe "#puts_self_in_check?" do
        let(:black_rook) { Rook.new("Black", game) }
        let(:white_king) { King.new("White", game) }

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

        it "returns true if the move would put the king in check" do
            black_rook.move(7, 3)
            white_king.move(4, 3)
            expect(white_king.puts_self_in_check?(2, 3)).to be true
        end

        it "returns false if the move would not put the king in check" do
            black_rook.move(7, 3)
            white_king.move(4, 4)
            expect(white_king.puts_self_in_check?(4, 5)).to be false
        end
    end

    describe "#castling?" do
        let(:white_rook) { Rook.new("White", game) }
        let(:white_king) { King.new("White", game) }
        let(:white_knight) { Knight.new("White", game) }
        let(:black_bishop) { Bishop.new("Black", game) }

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

        it "returns true if the king is able to castle" do
            white_king.move(7, 4)
            white_rook.move(7, 7)
            expect(white_king.castling?(7, 6)).to be true
            white_king.move(7, 4)
            white_rook.move(7, 0)
            expect(white_king.castling?(7, 2)).to be true
        end

        it "returns false if the king isnt able to castle due to a square not being empty" do
            white_king.move(7, 4)
            white_rook.move(7, 7)
            white_knight.move(7, 6)
            expect(white_king.castling?(7, 6)).to be false
        end

        it "returns false if the king isnt able to castle due to a square not being empty" do
            white_king.move(7, 4)
            white_rook.move(7, 0)
            white_knight.move(7, 2)
            expect(white_king.castling?(7, 2)).to be false
        end

        it "returns false if the king isnt able to castle due to a square being threatened" do
            white_king.move(7, 4)
            white_rook.move(7, 0)
            black_bishop.move(6, 4)
            expect(white_king.castling?(7, 2)).to be false
        end

        it "returns false if the king has already moved" do
            white_king.move(7, 4)
            white_king.has_moved
            white_rook.move(7, 0)
            black_bishop.move(6, 4)
            expect(white_king.castling?(7, 2)).to be false
        end

        it "returns false if the rook has already moved" do
            white_king.move(7, 4)
            white_rook.has_moved
            white_rook.move(7, 0)
            black_bishop.move(6, 4)
            expect(white_king.castling?(7, 2)).to be false
        end
    end
end
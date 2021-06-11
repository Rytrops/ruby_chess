require "./lib/chess_game.rb"

describe ChessGame do
    let(:game){ ChessGame.new }

    describe "#initialize" do
        it "sets the player turn to white" do
            expect(game.instance_variable_get(:@player_turn)).to eq("White")
        end
    end

    describe "#pass_turn" do
        it "passes the player turn from white to black and vice versa" do
            expect(game.instance_variable_get(:@player_turn)).to eq("White")
            game.pass_turn
            expect(game.instance_variable_get(:@player_turn)).to eq("Black")
            game.pass_turn
            expect(game.instance_variable_get(:@player_turn)).to eq("White")
        end

        it "passes the player turn from white to black and vice versa v.2" do
            expect { game.pass_turn }.to change { game.instance_variable_get(:@player_turn) }.from("White").to("Black")
            expect { game.pass_turn }.to change { game.instance_variable_get(:@player_turn) }.from("Black").to("White")
        end
    end

    describe "#player_in_check?" do
        let(:black_bishop) { Bishop.new("Black", game) }
        let(:white_king) { King.new("White", game) }
        let(:black_knight) { Knight.new("Black", game) }
        let(:white_rook) { Rook.new("White", game) }
        let(:black_rook) { Rook.new("Black", game) }
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
        it "returns true if the game is in check conditions" do
            white_king.move(5, 4)
            black_knight.move(6, 2)
            # black_bishop.move(1, 0)
            # white_rook.move(1, 3)
            expect(game.player_in_check?).to be true
        end
    end

    describe "#proper_length?" do
        it "returns true if the selection is the proper length" do
            expect(game.proper_length?("a2")).to be true
            expect(game.proper_length?("d5")).to be true
        end

        it "returns false if the selection is the improper length" do
            expect(game.proper_length?("a")).to be false
            expect(game.proper_length?("a2a3")).to be false
        end
    end

    describe "#location_on_the_board?" do
        it "returns true if the selection is on the board" do
            game.generate_board
            expect(game.location_on_the_board?("A", "7")).to be true
            expect(game.location_on_the_board?("D", "1")).to be true
            expect(game.location_on_the_board?("H", "5")).to be true
        end
        it "returns false if the selection is not on the board" do
            game.generate_board
            expect(game.location_on_the_board?("A", 7)).to be false
            expect(game.location_on_the_board?( "d", "1")).to be false
            expect(game.location_on_the_board?("5", "A")).to be false
        end
    end

    describe "#valid_selected_piece?" do

        it "returns true if the square selected has a piece the player is allowed to move" do
            game.generate_board
            game.instance_variable_set(:@selected_square, game.board[7][6])
            expect(game.valid_selected_piece?).to be true
        end

        it "returns false if the square selected has a piece the player is not allowed to move or is empty" do
            game.generate_board
            game.instance_variable_set(:@selected_square, game.board[0][3])
            expect(game.valid_selected_piece?).to be false
            game.instance_variable_set(:@selected_square, game.board[4][3])
            expect(game.valid_selected_piece?).to be false
        end
    end

    describe "#destination_on_the_board?" do

            it "returns true if the selection is on the board" do
                game.generate_board
                expect(game.location_on_the_board?("A", "7")).to be true
                expect(game.location_on_the_board?("D", "1")).to be true
                expect(game.location_on_the_board?("H", "5")).to be true
            end
            it "returns false if the selection is not on the board" do
                game.generate_board
                expect(game.location_on_the_board?("A", 7)).to be false
                expect(game.location_on_the_board?( "d", "1")).to be false
                expect(game.location_on_the_board?("5", "A")).to be false
            end
    end

    describe "#capture_piece" do
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
            # game.instance_variable_set(:@piece_destination, ["A", "3", nil, 3, 3])
            # game.instance_variable_set(:@moved_piece, ["white", nil, "A", "1" , 1, 3])    
            end

        it "only adds a captured enemy piece to an array contaning all captured pieces" do
            game.instance_variable_set(:@selected_square, Pawn.new("White", game))
            game.instance_variable_set(:@selected_square, nil)
            game.capture_piece
            game.instance_variable_set(:@selected_square, Pawn.new("Black", game))
            expect(game.capture_piece.length).to eq 1
            game.instance_variable_set(:@selected_square, Pawn.new("Black", game))
            expect(game.capture_piece.length).to eq 2
        end
    end
    
    describe "#king_locaiton" do
        let(:white_king) { King.new("White", game) }
        let(:black_king) { King.new("Black", game) }
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
        it "returns the location of the current player's king on the board" do
            white_king.move(5, 4)
            expect(game.king_location).to be_a King
        end
    end

    describe "#moves_to_clear_check" do
        let(:white_king) { King.new("White", game) }
        let(:black_knight) { Knight.new("Black", game) }
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

        it "returns an array with all moves that can clear check" do
            white_king.move(5, 4)
            black_knight.move(6, 2)
            expect(game.moves_to_clear_check).to be_a Array
            expect(game.moves_to_clear_check.empty?).to be false
        end
    end

    describe "#can_clear_check?" do 
    
        let(:white_king) { King.new("White", game) }
        let(:black_bishop) { Bishop.new("Black", game) }
        let(:white_rook) { Rook.new("White", game) }
        let(:black_rook) { Rook.new("Black", game) }
        let(:black_rook1) { Rook.new("Black", game) }

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
        
        it "returns true if check can be cleared by a piece other than the king" do
            white_king.move(5, 4)
            black_bishop.move(1, 0)
            white_rook.move(7, 3)
            expect(game.can_clear_check?).to be true
        end

        it "returns true if check can be cleared captuing the threatening piece" do
            white_king.move(5, 4)
            black_bishop.move(1, 0)
            white_rook.move(0, 0)
            expect(game.can_clear_check?).to be true
        end

        it "returns true if check can be cleared by the king moving" do
            white_king.move(2, 1)
            black_bishop.move(1, 0)
            expect(game.can_clear_check?).to be true
        end

        it "returns false if check cant be cleared" do
            white_king.move(2, 7)
            black_rook.move(1, 7)
            black_rook1.move(1, 6)
            expect(game.can_clear_check?).to be false
            black_rook.clear_piece
            black_rook1.clear_piece
        end
    end

    describe "#in_check_mate?" do
        
        let(:white_king) { King.new("White", game) }
        let(:black_bishop) { Bishop.new("Black", game) }
        let(:white_rook) { Rook.new("White", game) }
        let(:black_rook) { Rook.new("Black", game) }
        let(:black_rook1) { Rook.new("Black", game) }
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
        it "returns true if the player is in check mate" do
            white_king.move(2, 7)
            black_rook.move(1, 7)
            black_rook1.move(1, 6)
            expect(game.in_check_mate?).to be true
            black_rook.clear_piece
            black_rook1.clear_piece
        end
        it "returns false if player is not in check mate" do
            white_king.move(5, 4)
            black_bishop.move(1, 0)
            white_rook.move(7, 3)
            expect(game.in_check_mate?).to be false
        end

        it "returns false if player is not in check mate" do
            white_king.move(5, 4)
            black_bishop.move(1, 0)
            white_rook.move(0, 0)
            expect(game.in_check_mate?).to be false
        end

        it "returns false if player is not in check mate" do
            white_king.move(2, 1)
            black_bishop.move(1, 0)
            expect(game.in_check_mate?).to be false
        end
    end

    describe "#in_stale_mate?" do
    let(:white_king) { King.new("White", game) }
        let(:black_bishop) { Bishop.new("Black", game) }
        let(:white_rook) { Rook.new("White", game) }
        let(:black_rook) { Rook.new("Black", game) }
        let(:black_rook1) { Rook.new("Black", game) }

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

        it "returns true if the game is in stale mate" do
            white_king.move(7, 7)
            black_rook.move(6, 4)
            black_rook1.move(5, 6)
            expect(game.in_stale_mate?).to be true
        end

        it "returns false if the game is not in stale mate" do
            white_king.move(7, 7)
            black_rook.move(6, 4)
            black_rook1.move(5, 6)
            white_rook.move(0, 0)
            expect(game.in_stale_mate?).to be false
        end

    end
end
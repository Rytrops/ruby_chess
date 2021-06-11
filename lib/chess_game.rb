require "pry"
require_relative "./pieces.rb"
class ChessGame

    attr_accessor :board, :location, :destination

    WHITE_PIECES = ["♟︎", "♜", "♞", "♝", "♛", "♚"].freeze
    BLACK_PIECES = ["♙", "♖", "♘", "♗", "♕", "♔"].freeze
    EMPTY_SQUARE = nil.freeze
    ROW_MAPPING = {"1"=>7, "2"=>6, "3"=>5, "4"=>4, "5"=>3, "6"=>2, "7"=>1, "8"=>0}.freeze
    COLUMN_MAPPING = {"A" => 0, "B"=>1, "C"=>2, "D"=>3, "E"=>4, "F"=>5, "G"=>6, "H"=>7}.freeze

    def initialize 
        @player_turn = "White"
        @white_captures = []
        @black_captures = []
        @moved_piece = []
        @piece_destination = []
    end

    def generate_board
        @board = [
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
        @board[0][0] = Rook.new("Black", self)
        @board[0][7] = Rook.new("Black", self)
        @board[0][1] = Knight.new("Black", self)
        @board[0][6] = Knight.new("Black", self)
        @board[0][2] = Bishop.new("Black", self)
        @board[0][5] = Bishop.new("Black", self)
        @board[0][3] = Queen.new("Black", self)
        @board[0][4] = King.new("Black", self)
        @board[7][0] = Rook.new("White", self)
        @board[7][7] = Rook.new("White", self)
        @board[7][1] = Knight.new("White", self)
        @board[7][6] = Knight.new("White", self)
        @board[7][2] = Bishop.new("White", self)
        @board[7][5] = Bishop.new("White", self)
        @board[7][3] = Queen.new("White", self)
        @board[7][4] = King.new("White", self)
        @board.each_with_index do |row, index|
            if index == 1
                row.each_index do |square|
                    @board[index][square] = Pawn.new("Black", self)
                end
            elsif index == 6
                row.each_index do |square|
                    @board[index][square] = Pawn.new("White", self)
                end
            end
        end
    end

    def show_board
        @board.each_with_index do |row, idx| 
            row_string = "#{8-idx}"
            row.each do |square|
                square = " " if square.nil?
                row_string = row_string  + "[#{square} ]"
            end
            puts row_string
        end 
        puts "  A    B   C   D   E   F   G   H"
    end

    def gameplay_loop
        generate_board if @board.nil?
        until in_check_mate? || in_stale_mate?
            show_board
            select_piece
            until legal_piece_to_move?
                show_board
                select_piece
            end
            show_board
            select_destination
            until valid_destination?
                show_board
                select_destination
            end
            capture_piece
            store_last_move
            execute_move
            while @selected_piece.class == Pawn && @selected_piece.promotable?
                promote_pawn
            end
            pass_turn
            display_captured_pieces
            display_last_move
            sleep(1)
        end
        game_over
    end
    
    def pass_turn
        if @player_turn == "White"
            @player_turn = "Black"
        else
            @player_turn = "White"
        end
    end

    def select_piece
        puts "#{@player_turn}, which piece would you like to move?(ex. A2)"
        self.location = gets.upcase.chomp
        if  !legal_piece_to_move?
            puts "Sorry #{@player_turn}, that isn't a valid selection. Try again!"
            sleep(1)
        else
            @selected_piece = @selected_square
        end
    end

    def legal_piece_to_move?
        (proper_length?(location) && location_on_the_board?(location[0],location[1]) && valid_selected_piece?)
    end

    def proper_length?(selection)
        selection.length == 2
    end

    def location_on_the_board?(column_letter, row_number)
        @board_column_index_piece = COLUMN_MAPPING[column_letter]
        @board_row_index_piece = ROW_MAPPING[row_number]

        if !(@board_column_index_piece.nil? || @board_row_index_piece.nil?)
            @selected_square = @board[@board_row_index_piece][@board_column_index_piece]
            true            
        else
            false
        end
    end

    def valid_selected_piece?
        return false if @selected_square.nil?
        @selected_square.team == @player_turn && !@selected_square.available_moves.empty?
    end

    def select_destination
        puts "#{@player_turn}, where would you like to move the #{@selected_piece} ?(ex. A2)"
        self.destination = gets.upcase.chomp
        if !valid_destination?
            puts "Sorry #{@player_turn}, that isn't a valid selection. Try again!"
            sleep(1)
        end
    end

    def valid_destination?
        (proper_length?(destination) && destination_on_the_board?(destination[0],destination[1]) && @selected_piece.legal_move?(@board_row_index_destination, @board_column_index_destination))
    end

    def destination_on_the_board?(column_letter, row_number)
        @board_column_index_destination = COLUMN_MAPPING[column_letter]
        @board_row_index_destination = ROW_MAPPING[row_number]
        if !(@board_column_index_destination.nil? || @board_row_index_destination.nil?)
            @selected_square = @board[@board_row_index_destination][@board_column_index_destination]
            true            
        else
            false
        end
    end
    
    def store_last_move
        @moved_piece = [@player_turn, @selected_piece.class, location[0], location[1], @board_row_index_piece, @board_column_index_piece]
        if @selected_square.nil?
            @piece_destination = [destination[0],destination[1], @board_row_index_destination, @board_column_index_destination]
        else
            @piece_destination = [destination[0], destination[1], @selected_square, @board_row_index_destination, @board_column_index_destination]
        end
    end

    def display_last_move
        player = @moved_piece[0]
        piece_moved = @moved_piece[1]
        piece_column =@moved_piece[2]
        piece_row =@moved_piece[3]
        destination_row = @piece_destination[0]
        destination_column = @piece_destination[1]
        destination_piece = @piece_destination[2]

        if destination_piece.nil? || destination_piece.integer?
            capture = ""
        else
            capture = "to capture the #{destination_piece.class}"
        end

        puts "#{player}, moved the #{piece_moved} from #{piece_column}#{piece_row} to #{destination_row}#{destination_column} #{capture}"

    end

    def capture_piece
        if (white_turn? && (@selected_square.nil? || @selected_square.team != @player_turn))
            if  @selected_piece.class == Pawn && @selected_piece.is_enpassante?(@board_row_index_destination, @board_column_index_destination)
                captured_pawn = @board[@board_row_index_destination + 1][@board_column_index_destination]
                @board[@board_row_index_destination + 1][@board_column_index_destination] = nil
                @white_captures << captured_pawn.display
            elsif !@selected_square.nil?
                @white_captures << @selected_square.display
            end
        elsif (black_turn? && !@selected_square.nil? && @selected_square.team != @player_turn)
            if  @selected_piece.class == Pawn && @selected_piece.is_enpassante?(@board_row_index_destination, @board_column_index_destination)
                captured_pawn = @board[@board_row_index_destination + 1][@board_column_index_destination]
                @board[@board_row_index_destination + 1][@board_column_index_destination] = nil
                @black_captures << captured_pawn.display
            else
                @black_captures << @selected_square.display
            end
        end
    end

    def display_captured_pieces
        puts "Black captures: #{@black_captures}"
        puts "White captures: #{@white_captures}"
    end

    def execute_move
        @selected_piece.has_moved = true
        board[@board_row_index_piece][@board_column_index_piece] = EMPTY_SQUARE
        board[@board_row_index_destination][@board_column_index_destination] = @selected_piece
    end

    def player_in_check?
        !king_location.threatening_pieces.empty?
    end

    def king_location
        board.flatten.each do |square|
            if !square.nil? && square.class == King
                if square.team == "White" && white_turn?
                    return square
                elsif square.team == "Black" && black_turn?
                    return square
                end 
            end
        end
    end

    def moves_to_clear_check
        moves = []
        moves.concat(king_location.threatening_pieces).concat(king_location.threatening_pieces[0][2].squares_to_king)
    end

    def can_clear_check?
        moves = moves_to_clear_check
        @board.flatten.each do |square|
            if !square.nil? && square.team == @player_turn
                moves.each do |position|
                    if square.legal_move?(position[0],position[1]) && square.class != King
                        return true
                    elsif square.class == King && !square.available_moves.empty? &&!square.available_moves.include?([position[0], position[1]])
                        return true
                    end
                end
            end
        end
        return false
    end

    def promote_pawn
        puts " #{@player_turn}, what would you like the pawn to promote to? (Rook, Bishop, Queen, Knight)"
        promotion = gets.capitalize.chomp
        row = @selected_piece.row
        column = @selected_piece.column
        case promotion
        when "Rook"
            @board[row][column] = Rook.new("#{@player_turn}", self)
        when "Bishop"
            @board[row][column] = Bishop.new("#{@player_turn}", self)
        when "Queen"
            @board[row][column] = Queen.new("#{@player_turn}", self)
        when "Knight"
            @board[row][column] = Knight.new("#{@player_turn}", self)
        else 
            puts "Sorry #{@player_turn}, that isn't a valid option, try again"
            sleep(1)
        end
        @selected_piece = @board[row][column]
    end

    def in_check_mate?
        player_in_check? && !can_clear_check?
    end

    def in_stale_mate?
        @board.flatten.each do |square|
            if !square.nil? && square.team == @player_turn && !square.available_moves.empty?
                return false
            end
        end
        true
    end
    
    def game_over
        puts "Sorry #{@player_turn} you're a loser!"
    end

    def black_turn? 
        @player_turn == "Black"
    end

    def white_turn?
        @player_turn == "White"
    end
end


class Piece

    attr_accessor :team, :has_moved

    def initialize(team, game)
        @team = team
        @game = game
        self.has_moved = false
    end

    def to_s
        display
    end

    def board
        @game.board
    end

    def row
        location = board.flatten.index(self)
        location / 8
    end
    
    def column
        location = board.flatten.index(self)
        location % 8
    end

    def row_distance(destination_row)
        (row - destination_row).abs
        
    end

    def column_distance(destination_column)
        (column - destination_column).abs
    end

    def display
        if @team == "White"
            self.class::WHITE_ICON
        else
            self.class::BLACK_ICON
        end
    end

    def on_board?
        !board.flatten.index(self).nil?
    end

    def move(destination_row, destination_column)
        board[row][column] = nil if on_board?
        board[destination_row][destination_column] = self

    end

    def legal_move?(destination_row,destination_column)
        raise "not implemented"
    end

    def valid_destination?(destination_row, destination_column)
        board[destination_row][destination_column].nil? || board[destination_row][destination_column].team != self.team
    end

    def error_illegal_move
        raise "illegal move"
    end

    def available_moves
        avail_moves = []
        board.each_index do |row_index|
            board.transpose.each_index do |column_index|
                 if self.legal_move?(row_index, column_index)
                    stored_square = [row_index, column_index]
                    avail_moves << stored_square
                 end
            end
        end
        avail_moves
    end

    def clear_piece
        board[self.row][self.column] = nil
    end

    def squares_to_king
        squares = []
    end

    def threatening_pieces
        @game.king_location.threatening_pieces
    end

    def name
        [self.class, self.team]
    end

end

class Pawn < Piece
    # still need to do enpassante
    WHITE_ICON = "♟︎".freeze
    BLACK_ICON = "♙".freeze
    def legal_move?(destination_row,destination_column)
        if @team == "White"
            #make each a method and triple or in one line check the parathesis!
            double_move = (row == 6 && destination_row == 4) && column == destination_column && board[row-1][column].nil? && valid_destination?(destination_row, destination_column) 
            single_move = row == (destination_row+1) && column == destination_column && board[destination_row][destination_column].nil?
            diag_capture = row == (destination_row+1) && ((column-1) == destination_column || (column+1) == destination_column) && !board[destination_row][destination_column].nil? && board[destination_row][destination_column].team != self.team
            double_move || single_move || diag_capture || is_enpassante?(destination_row,destination_column)
        elsif @team == "Black"
            double_move = ((row == 1 && destination_row == 3) && column == destination_column && board[row+1][column].nil?)
            single_move =(row == (destination_row-1) && column == destination_column && board[destination_row][destination_column].nil?) 
            diag_capture = ((row == (destination_row-1) && ((column-1) ==  destination_column || (column+1) == destination_column )) && (!board[destination_row][destination_column].nil?) && (board[destination_row][destination_column].team != self.team)) 
            double_move || single_move || diag_capture || is_enpassante?(destination_row,destination_column)
        else
            false
        end
    end
    
    def is_enpassante?(destination_row,destination_column)
        moved_piece = @game.instance_variable_get(:@moved_piece)
        piece_destination = @game.instance_variable_get(:@piece_destination)
        enemy_pawn_double_moved = moved_piece[1] == Pawn && (moved_piece[4] - piece_destination[-2]).abs == 2
        enemy_pawn_is_adjacent = row == piece_destination[-2] && (column == piece_destination[-1] + 1 || column == piece_destination[-1] - 1)
        if team == "White"
            diagonal_move = destination_column == moved_piece[5] && destination_row == moved_piece[4] + 1
        else
            diagonal_move = destination_column == moved_piece[5] && destination_row == moved_piece[4] - 1
        end
        enemy_pawn_double_moved && enemy_pawn_is_adjacent && diagonal_move
    end

    def promotable?
        row == 0 || row == 7
    end
end

class King < Piece

    WHITE_ICON = "♚".freeze
    BLACK_ICON = "♔".freeze

    def legal_move?(destination_row, destination_column)
        return true if (valid_move?(destination_row, destination_column) && valid_destination?(destination_row, destination_column) && !(puts_self_in_check?(destination_row, destination_column))) || (castling?(destination_row, destination_column))
        false
    end

    def castling?(destination_row, destination_column)
        if !self.nil? && !self.has_moved && self.row == destination_row && destination_column == 6 && !board[destination_row][destination_column + 1].nil? && !board[destination_row][destination_column + 1].has_moved
            squares_to_check = [[self.row, destination_column - 1], [self.row, destination_column]]
            squares_to_check.each do |square| 
               if !board[square[0]][square[1]].nil? || puts_self_in_check?(square[0], square[1])
                    return false
               end
            end
            return true
        elsif !self.nil? && !self.has_moved && self.row == destination_row && destination_column == 2 && !board[destination_row][destination_column - 2].nil? && !board[destination_row][destination_column - 2].has_moved
            squares_to_check = [[self.row, destination_column - 1], [self.row, destination_column + 1], [self.row, destination_column]]
            squares_to_check.each do |square| 
                if !board[square[0]][square[1]].nil? || puts_self_in_check?(square[0], square[1])
                    return false
                end
            end
            return true
        end
    end

    def valid_move?(destination_row, destination_column)
        row_distance = (row - destination_row).abs
        column_distance = (column - destination_column).abs
        row_distance<= 1 && column_distance <= 1
    end

    def spoof_move(destination_row, destination_column)
        stored_positions = []
        piece = self
        piece_row = self.row
        piece_column = self.column
        destination_square = board[destination_row][destination_column]
        board[destination_row][destination_column] = piece
        board[piece_row][piece_column] = nil
        return stored_positions = [destination_square, destination_row, destination_column, piece, piece_row, piece_column]
    end

    def unspoof_move(stored_positions)
        board[stored_positions[1]][stored_positions[2]] = stored_positions[0]
        board[stored_positions[4]][stored_positions[5]] = stored_positions[3]
    end

    def puts_self_in_check?(destination_row, destination_column)
        stored_positions = spoof_move(destination_row, destination_column)
        board.flatten.each do |square|
            if !square.nil? && square.team != self.team && square.class != King && square.available_moves.include?([destination_row, destination_column])
                unspoof_move(stored_positions)
                return true
            elsif square.class == King && square != self
                unspoof_move(stored_positions)
                return destination_adjacent_to_enemy_king?(destination_row, destination_column, square)
            end
        end
        unspoof_move(stored_positions)
        false
    end

    def destination_adjacent_to_enemy_king?(destination_row, destination_column, square)
        diagonally_adjacent =  (destination_row == square.row - 1 || destination_row == square.row + 1) && (destination_column == square.column + 1 || destination_column == square.column - 1)
        vertically_adjacent = ((destination_row == square.row - 1 || destination_row == square.row + 1) && destination_column == square.column)
        horizontally_adjacent = (destination_row == square.row && (destination_column == square.column + 1 || destination_column == square.column - 1))
        diagonally_adjacent || vertically_adjacent || horizontally_adjacent
    end

    def threatening_pieces
        pieces = []
        board.flatten.each do |square|
            if !square.nil? && square.legal_move?(self.row, self.column)
                stored_piece = [square.row, square.column, square]
                pieces << stored_piece
            end
        end
        return pieces
    end

    def check_mate?
        in_check? && !clear_check?
    end

    def in_check?
        !threatening_pieces.empty?
    end
end

class Knight < Piece

    WHITE_ICON = "♞".freeze
    BLACK_ICON = "♘".freeze

    def legal_move?(destination_row,destination_column)
            #knight can move one row over and two columns over or two rows over and one column over, to capture piece or empty square, jumps ove runits
            #one row, two column move
            return true if  (row == destination_row + 1 || row == destination_row - 1) && (column == destination_column + 2 || column == destination_column - 2) && valid_destination?(destination_row, destination_column)
            return true if (row == destination_row + 2 || row == destination_row - 2) && (column == destination_column + 1 || column == destination_column - 1) && valid_destination?(destination_row, destination_column)
            false
    end
end

class Bishop < Piece

    WHITE_ICON = "♝".freeze
    BLACK_ICON = "♗".freeze

    def legal_move?(destination_row,destination_column)
        # The bishop moves in a straight diagonal line. The bishop may also not jump over other pieces.
        if row_distance(destination_row) == 1 && column_distance(destination_column) == 1 && valid_destination?(destination_row, destination_column)
            true
        elsif row_distance(destination_row) == column_distance(destination_column) && valid_destination?(destination_row, destination_column)
            if row > destination_row && column > destination_column
                (row_distance(destination_row)-1).times do |squares_moved|
                    if (board[row-squares_moved-1][column-squares_moved-1].nil?)
                        next
                    else
                        return false
                    end
                end
                return true
            elsif (row > destination_row) && (column < destination_column)
                (row_distance(destination_row)-1).times do |squares_moved|
                    if board[row-squares_moved-1][column+squares_moved+1].nil?
                        next
                    else
                        return false
                    end
                end
                return true
            elsif row < destination_row && column > destination_column
                (row_distance(destination_row)-1).times do |squares_moved|
                    if board[row+squares_moved+1][column-squares_moved-1].nil?
                        next
                    else
                        return false
                    end
                end
                return true
            elsif row < destination_row && column < destination_column
                (row_distance(destination_row)-1).times do |squares_moved|
                    if board[row+squares_moved+1][column+squares_moved+1].nil?
                        next
                    else
                        return false
                    end
                end
                return true
            end
        else
            false
        end 
    end

    def squares_to_king
        squares = []
        available_moves.each do |square|
            if square[0].between?(self.row, @game.king_location.row) && square[1].between?(self.column, @game.king_location.column)
                squares.concat([square])
            elsif square[0].between?(self.row, @game.king_location.row) && square[1].between?(@game.king_location.column, self.column)
                squares.concat([square])
            elsif square[0].between?(@game.king_location.row, self.row) && square[1].between?(self.column, @game.king_location.column)
                squares.concat([square])
            elsif square[0].between?(@game.king_location.row, self.row) && square[1].between?(@game.king_location.column, self.column)
                squares.concat([square])
            end
        end
        return squares
    end
end

class Rook < Piece
    WHITE_ICON = "♜".freeze
    BLACK_ICON = "♖".freeze

    def legal_move?(destination_row, destination_column)
        # can move horizontally either through a column or through a row.  can move up to the length of the board if unobstructed
        if ((row_distance(destination_row) == 0 && column_distance(destination_column) == 1) || (row_distance(destination_row) == 1 && column_distance(destination_column) == 0)) && valid_destination?(destination_row, destination_column)
            return true
        elsif row_distance(destination_row) == 0 && column_distance(destination_column) > 1 && valid_destination?(destination_row, destination_column)
            if column > destination_column
                (column_distance(destination_column)-1).times do |squares_moved|
                    if board[row][column-squares_moved-1].nil?
                        next
                    else
                        return false
                    end
                end
                return true
            elsif column < destination_column
                (column_distance(destination_column)-1).times do |squares_moved|
                    if board[row][column+squares_moved+1].nil?
                        next
                    else
                        return false
                    end
                end
                return true
            end
        elsif row_distance(destination_row) > 1 && column_distance(destination_column) == 0 && valid_destination?(destination_row, destination_column)
            if row > destination_row
                (row_distance(destination_row)-1).times do |squares_moved|
                    if board[row-squares_moved-1][column].nil?
                        next
                    else
                        return false
                    end
                end
                return true
            elsif row < destination_row
                (row_distance(destination_row)-1).times do |squares_moved|
                    if board[row+squares_moved+1][column].nil?
                        next
                    else
                        return false
                    end
                end
                return true
            end
        else
            false
        end
    end

    def squares_to_king
        squares = []
        available_moves do |square|
            if square[0] == @game.king_location.row && (square[1].between?(self.column, @game.king_location.column) || square[1].between?(@game.king_location.column, self.column))
                squares.concat([square])
            elsif square[1] == @game.king_location.column && (square[1].between?(self.row, @game.king_location.row) || square[1].between?(@game.king_location.row, self.row))
                squares.concat([square])
            
            end
        end
        return squares
    end
end

class Queen < Piece

    WHITE_ICON = "♛".freeze
    BLACK_ICON = "♕".freeze

    def legal_move?(destination_row, destination_column)

        if row_distance(destination_row) == 1 && column_distance(destination_column) == 1 && valid_destination?(destination_row, destination_column)
            true
        elsif row_distance(destination_row) == column_distance(destination_column) && valid_destination?(destination_row, destination_column)
            if row > destination_row && column > destination_column
                (row_distance(destination_row)-1).times do |squares_moved|
                    if (board[row-squares_moved-1][column-squares_moved-1].nil?)
                        next
                    else
                        return false
                    end
                end
                return true
            elsif (row > destination_row) && (column < destination_column)
                (row_distance(destination_row)-1).times do |squares_moved|
                    if board[row-squares_moved-1][column+squares_moved+1].nil?
                        next
                    else
                        return false
                    end
                end
                return true
            elsif row < destination_row && column > destination_column
                (row_distance(destination_row)-1).times do |squares_moved|
                    if board[row+squares_moved+1][column-squares_moved-1].nil?
                        next
                    else
                        return false
                    end
                end
                return true
            elsif row < destination_row && column < destination_column
                (row_distance(destination_row)-1).times do |squares_moved|
                    if board[row+squares_moved+1][column+squares_moved+1].nil?
                        next
                    else
                        return false
                    end
                end
                return true
            end
        elsif ((row_distance(destination_row) == 0 && column_distance(destination_column) == 1) || (row_distance(destination_row) == 1 && column_distance(destination_column) == 0)) && valid_destination?(destination_row, destination_column)
            true
        elsif row_distance(destination_row) == 0 && column_distance(destination_column) > 1 && valid_destination?(destination_row, destination_column)
            if column > destination_column
                (column_distance(destination_column)-1).times do |squares_moved|
                    if board[row][column-squares_moved-1].nil?
                        next
                    else
                        return false
                    end
                end
                return true
            elsif column < destination_column
                (column_distance(destination_column)-1).times do |squares_moved|
                    if board[row][column+squares_moved+1].nil?
                        next
                    else
                        return false
                    end
                end
                return true
            end
        elsif row_distance(destination_row) > 1 && column_distance(destination_column) == 0 && valid_destination?(destination_row, destination_column)
            if row > destination_row
                (row_distance(destination_row)-1).times do |squares_moved|
                    if board[row-squares_moved-1][column].nil?
                        next
                    else
                        return false
                    end
                end
                return true
            elsif row < destination_row
                (row_distance(destination_row)-1).times do |squares_moved|
                    if board[row+squares_moved+1][column].nil?
                        next
                    else
                        return false
                    end
                end
                return true
            end
        else
            false
        end
    end
    
    def squares_to_king
        squares = []
        available_moves do |square|
            if square[0] == @game.king_location.row && (square[1].between?(self.column, @game.king_location.column) || square[1].between?(@game.king_location.column, self.column))
                squares.concat([square])
            elsif square[1] == @game.king_location.column && (square[1].between?(self.row, @game.king_location.row) || square[1].between?(@game.king_location.row, self.row))
                squares.concat([square])
            elsif square[0].between?(self.row, @game.king_location.row) && square[1].between?(self.column, @game.king_location.column)
                squares.concat([square])
            elsif square[0].between?(self.row, @game.king_location.row) && square[1].between?(@game.king_location.column, self.column)
                squares.concat([square])
            elsif square[0].between?(@game.king_location.row, self.row) && square[1].between?(self.column, @game.king_location.column)
                squares.concat([square])
            elsif square[0].between?(@game.king_location.row, self.row) && square[1].between?(@game.king_location.column, self.column)
                squares.concat([square])
            end
        end
        return squares
    end
end
require_relative 'reader'

class ErrorChecker < FileLector
    def new_line(line, lines_counter)
        @line = line
        @lines_counter = lines_counter
        @empty_spaces_counter = 0
        @error_message = ""
    end
end
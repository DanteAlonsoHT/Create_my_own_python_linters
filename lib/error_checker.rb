require_relative 'reader'

class ErrorChecker < FileLector
    def new_line(line, lines_counter)
        @line = line
        @lines_counter = lines_counter
        @empty_spaces_counter = 0
        @error_message = ""
    end

    def check_indentation
        @line.split(//).each do |likely_space|
            @empty_spaces_counter +=1 if likely_space == " "
            @empty_spaces_counter = 0 if ((@empty_spaces_counter == 1) && (likely_space != " "))
            @empty_spaces_counter = 0 if ((@empty_spaces_counter % 4 == 0) && (likely_space != " "))
        end
        if @empty_spaces_counter == 1
            @error_message.concat("#{lines_counter}:1 Expected indentation of 0 spaces\n")
        elsif @empty_spaces_counter % 4 != 0
            @error_message.concat("#{lines_counter}:1 Expected indentation of 4 spaces\n")
            @error_message.concat("#{@empty_spaces_counter} space(s) found\n")
        end
    end
end
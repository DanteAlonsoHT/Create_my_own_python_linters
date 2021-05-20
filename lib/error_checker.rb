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

    def check_errors
        if @line.match(/\w=/)
            @error_message.concat("#{@lines_counter}:#{(@line =~ /\w=/) + 1} Expected whitespace before '='\n")
            @error_message.concat("\s\n#{@line}\n")
            (@line =~ /\w=/).to_i.times { |i| @error_message.concat("\s") }
            @error_message.concat("\s^\n")
        end
        if @line.match(/=\w/)
            @error_message.concat("#{@lines_counter}:#{(@line =~ (/=\w/)) + 1} Expected whitespace after '='")
            @error_message.concat("\s\n#{@line}\n")
            (@line =~ (/=\w/)).to_i.times { |i| @error_message.concat("\s") }
            @error_message.concat("\s^\n")
        end
        if @line.match(/[a-z]\s:/)
            @error_message.concat("#{@lines_counter}:#{(@line =~ /[a-z]\s:/) + 1} Unexpected whitespace before ':'")
            @error_message.concat("\s\n#{@line}\n")
            (@line =~ /[a-z]\s:/).to_i.times { |i| @error_message.concat("\s") }
            @error_message.concat("\s^\n")
        end
        if @line.match(/:\s\s/)
            @error_message.concat("#{@lines_counter}:#{(@line =~ /:\s\s/) + 1} Unexpected whitespace after ':'")
            @error_message.concat("\s\n#{@line}\n")
            (@line =~ /:\s\s/).to_i.times { |i| @error_message.concat("\s") }
            @error_message.concat("\s^\n")
        end
        if @line.match(/,\w/)
            @error_message.concat("#{@lines_counter}:#{(@line =~ /,\w/) + 1} Missing whitespace after ','")
            @error_message.concat("\s\n#{@line}\n")
            (@line =~ /,\w/).to_i.times { |i| @error_message.concat("\s") }
            @error_message.concat("\s^\n")
        end
        if @line.match(/\w\s\s+/)
            @error_message.concat("#{@lines_counter}:#{(@line =~ /\w\s\s+/) + 1} multiple spaces after keyword")
            @error_message.concat("\s\n#{@line}\n")
            (@line =~ /\w\s\s+/).to_i.times { |i| @error_message.concat("\s") }
            @error_message.concat("\s^\n")
        end
        if @line.match(/print\s+/)
            @error_message.concat("#{@lines_counter}:#{(@line =~ /t\s+/)} Unexpected whitespace(s) after 'print'")
            @error_message.concat("\s\n#{@line}\n")
            (@line =~ /t\s+/).to_i.times { |i| @error_message.concat("\s") }
            @error_message.concat("\s^\n")
        end
        if @line.match(/#\w/)
            @error_message.concat("#{@lines_counter}:#{(@line =~ (/#\w/))} Expected whitespace after '#' for comments")
            @error_message.concat("\s\n#{@line}\n")
            (@line =~ /#\w/).to_i.times { |i| @error_message.concat("\s") }
            @error_message.concat("\s^\n")
        end
    end

    def check_empty_spaces
        @line.scan(/\w+/).empty? ? @empty_lines += 1 : @empty_lines = 0
        if @empty_lines > 1
            @error_message.concat("#{@lines_counter}:0 x Unexpected extra enter line(s) in the code\s")
        end
    end
end
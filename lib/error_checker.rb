require_relative 'reader'
require 'colorize'

class ErrorChecker < FileLector
  @empty_lines = 0
  def new_line(line, lines_counter)
    @line = line
    @lines_counter = lines_counter
    @empty_spaces_counter = 0
    @error_message = ''
  end

  # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

  def check_indentation
    @line.chars.each do |likely_space|
      @empty_spaces_counter += 1 if likely_space == ' '
      @empty_spaces_counter = 0 if (@empty_spaces_counter == 1) && (likely_space != ' ')
      @empty_spaces_counter = 0 if (@empty_spaces_counter % 4).zero? && (likely_space != ' ')
    end
    if @empty_spaces_counter == 1
      @error_message.concat("#{lines_counter}:1 Expected indentation of 0 spaces\n")
    elsif @empty_spaces_counter % 4 != 0
      @error_message.concat("#{lines_counter}:1 Expected indentation of 4 spaces\n")
      @error_message.concat("#{@empty_spaces_counter} space(s) found\n")
    end
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength

  def check_errors
    if @line.match(/\w=/)
      @error_message.concat("#{@lines_counter}:#{(@line =~ /\w=/) + 1} Expected whitespace before ´=´")
      @error_message.concat("\s\n#{@line}")
      (@line =~ /\w=/).to_i.times { |_i| @error_message.concat("\s") }
      @error_message.concat("\s^\n")
    end
    if @line.match(/=\w/)
      @error_message.concat("#{@lines_counter}:#{(@line =~ (/=\w/)) + 1} Expected whitespace after ´=´")
      @error_message.concat("\s\n#{@line}")
      (@line =~ (/=\w/)).to_i.times { |_i| @error_message.concat("\s") }
      @error_message.concat("\s^\n")
    end
    if @line.match(/[a-z]\s:/)
      @error_message.concat("#{@lines_counter}:#{(@line =~ /[a-z]\s:/) + 1} Unexpected whitespace before ´:´")
      @error_message.concat("\s\n#{@line}")
      (@line =~ /[a-z]\s:/).to_i.times { |_i| @error_message.concat("\s") }
      @error_message.concat("\s^\n")
    end
    if @line.match(/:\s\s/)
      @error_message.concat("#{@lines_counter}:#{(@line =~ /:\s\s/) + 1} Unexpected whitespace after ´:´")
      @error_message.concat("\s\n#{@line}")
      (@line =~ /:\s\s/).to_i.times { |_i| @error_message.concat("\s") }
      @error_message.concat("\s^\n")
    end
    if @line.match(/,\w/)
      @error_message.concat("#{@lines_counter}:#{(@line =~ /,\w/) + 1} Missing whitespace after ´,´")
      @error_message.concat("\s\n#{@line}")
      (@line =~ /,\w/).to_i.times { |_i| @error_message.concat("\s") }
      @error_message.concat("\s^\n")
    end
    if @line.match(/\w\s\s+/)
      @error_message.concat("#{@lines_counter}:#{(@line =~ /\w\s\s+/) + 1} multiple spaces after keyword")
      @error_message.concat("\s\n#{@line}")
      (@line =~ /\w\s\s+/).to_i.times { |_i| @error_message.concat("\s") }
      @error_message.concat("\s^\n")
    end
    if @line.match(/print\s+/)
      @error_message.concat("#{@lines_counter}:#{@line =~ /t\s+/} Unexpected whitespace(s) after ´print´")
      @error_message.concat("\s\n#{@line}")
      (@line =~ /t\s+/).to_i.times { |_i| @error_message.concat("\s") }
      @error_message.concat("\s^\n")
    end
    # rubocop:disable Style/GuardClause
    if @line.match(/#\w/)
      @error_message.concat("#{@lines_counter}:#{@line =~ (/#\w/)} Expected whitespace after ´#´ in comments")
      @error_message.concat("\s\n#{@line}")
      (@line =~ (/#\w/)).to_i.times { |_i| @error_message.concat("\s") }
      @error_message.concat("\s^\n")
    end
    # rubocop:enable Style/GuardClause
  end

  # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity,
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength,

  def check_empty_spaces
    @line.scan(/\w+/).empty? ? @empty_lines += 1 : @empty_lines = 0
    @error_message.concat("#{@lines_counter}:0 Unexpected extra enter line(s) in the code\s") if @empty_lines > 1
  end

  def add_color_to_message
    @error_message.split(/ /).each do |line_alert|
      if line_alert.match(/[0-9]:[0-9]/)
        print "\n[#{@file_path.colorize(:blue)}]:[#{'Linter Error'.colorize(:red)}]:#{line_alert.colorize(:yellow)}"
      elsif line_alert.match(/´/) && !line_alert.match(/\n\w+/)
        print "\s#{line_alert.colorize(:magenta)}"
      else
        print "\s#{line_alert.colorize(:white)}"
      end
    end
  end
end

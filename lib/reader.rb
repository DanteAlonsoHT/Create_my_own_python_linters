class FileLector
    attr_accessor :file_path, :lines_counter
    def initialize(file_path)
        @file_path = file_path
        @lines_counter = 0
    end

    def line_counter
        @lines_counter = @lines_counter + 1 
        @lines_counter
    end
end
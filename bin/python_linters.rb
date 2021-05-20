require_relative '../lib/error_checker'

python_linter = ErrorChecker.new('test\test.py')

File.foreach(python_linter.file_path) do |line|
  python_linter.new_line(line, python_linter.line_counter)
  python_linter.check_empty_spaces
  python_linter.check_indentation
  python_linter.check_errors
  print python_linter.add_color_to_message
end

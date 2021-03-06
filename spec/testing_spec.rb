# rubocop:disable Style/GlobalVars

require_relative '../bin/python_linters'

test_linter = ErrorChecker.new('test/test.py')
File.foreach(test_linter.file_path) { |line| $line = line }

describe 'ErrorChecker' do
  describe '#file_path' do
    it 'returns the same path declared previously' do
      expect(test_linter.file_path).to eql 'test/test.py'
    end
    it 'returns true if there is a python file' do
      expect(test_linter.file_path.end_with?('.py')).to eql true
    end
  end

  describe '#line_counter' do
    it 'returns 1 because it is the first time used' do
      expect(test_linter.line_counter).to eql 1
    end
    it 'returns 2 because it is the second time used' do
      expect(test_linter.line_counter).to eql 2
    end
    it 'returns 3, 3 is not zero' do
      expect(test_linter.line_counter.zero?).to eql false
    end
  end

  describe '#new_line' do
    it "returns '' because it should return empty string" do
      expect(test_linter.new_line($line, test_linter.line_counter)).to eql ''
    end
    it 'returns true because it should return empty string' do
      expect(test_linter.new_line($line, test_linter.line_counter).empty?).to eql true
    end
  end

  describe '#check_empty_spaces' do
    it 'returns error_message in the line 8 when the second empty line starts' do
      test_linter.check_empty_spaces
      test_linter.new_line("\n", 7)
      test_linter.check_empty_spaces
      test_linter.new_line("\n", 8)
      expect(test_linter.check_empty_spaces).to eql '8:0 Unexpected extra enter line(s) in the code '
    end
    it 'returns false because there are 2 empty lines' do
      expect(test_linter.empty_lines.zero?).to eql false
    end
  end

  describe '#check_indentation' do
    it 'returns error_message in line 9 and it shows the number of spaces are expected and were found' do
      test_linter.new_line('  print(5)', 9)
      expect(test_linter.check_indentation).to eql "9:1 Expected indentation of 4 spaces\n2 space(s) found\n"
    end
    it 'returns nil because there are correct indentation' do
      test_linter.new_line('    print(5)', 10)
      expect(test_linter.check_indentation).to eql nil
    end
  end

  describe '#check_errors' do
    it 'returns error_message in line 10, it should show an expected whitespace after ??=??' do
      test_linter.new_line('hola =5', 10)
      test_linter.check_errors
      expect(test_linter.error_message).to eql "10:6 Expected whitespace after ??=?? \nhola =5      ^\n"
    end
    it 'returns true because check_errors was not used to detect errors' do
      test_linter.new_line('hola =5', 10)
      expect(test_linter.error_message.empty?).to eql true
    end
  end

  describe '#add_color_to_message' do
    it 'returns false when error_message has error to print' do
      test_linter.new_line('   print(6)', 12)
      test_linter.check_indentation
      expect(test_linter.add_color_to_message.empty?).to eql false
    end
    it 'returns true when error_message has not error to print' do
      test_linter.new_line('print(6)', 12)
      test_linter.check_indentation
      expect(test_linter.add_color_to_message.empty?).to eql true
    end
  end
end

# rubocop:enable Style/GlobalVars

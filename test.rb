require_relative "./tests/registers_test"
require_relative "./tests/executor_test"
require_relative "./tests/display_test"

INSTRUCTION_PARSERS_TESTS_PATH = "/tests/instruction_parser/"
instruction_parser_test_files = Dir.glob(File.join(__dir__, INSTRUCTION_PARSERS_TESTS_PATH, '*.rb'))
instruction_parser_test_files.map do |test_path|
  require_relative test_path
end

require_relative "./tests/registers_test"
require_relative "./tests/executor_test"
require_relative "./tests/display_test"

COMMAND_PARSERS_TESTS_PATH = "/tests/command_parser/"
command_parser_test_files = Dir.glob(File.join(__dir__, COMMAND_PARSERS_TESTS_PATH, '*.rb'))
command_parser_test_files.map do |test_path|
  require_relative test_path
end

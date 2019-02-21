require "bundler/setup"
require "thor_repl"

require 'tempfile'

module RspecDescribeHelpers
  def with_temp_file(filename, identifier = :temp_file)
    contents = block_given? ? yield : ""

    let identifier do
      Tempfile.new filename
    end

    before do
      self.send(identifier).write contents
      self.send(identifier).close
    end

    after do
      self.send(identifier).close
      self.send(identifier).unlink
    end
  end
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.extend RspecDescribeHelpers
end

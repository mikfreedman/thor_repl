module ThorRepl
  class History

    attr_reader :history_file

    def initialize(readline_history: Readline::HISTORY, history_file_path: ThorRepl::HISTORY_FILE_PATH)
      @readline_history = readline_history
      @history_file = history_file_path && File.expand_path(history_file_path)
    end

    def self.with_history(**opts, &block)
      history = self.new(**opts)
      history.read_history
      block.call
    ensure
      history.write_history
    end

    def read_history
      if history_file && File.exists?(history_file)
        IO.readlines(history_file).each { |e| @readline_history << e.chomp }
      end
    end

    def write_history
      if history_file
        File.open(history_file, "w") { |f| f.puts(*Array(@readline_history)) }
      end
    end
  end
end

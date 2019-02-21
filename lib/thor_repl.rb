require "thor_repl/version"
require "thor_repl/looper"
require "thor_repl/history"

module ThorRepl
  HISTORY_FILE_PATH = ENV.fetch("THOR_REPL_HISTORY_FILE", "~/.thor_repl_history")

  def self.start(thor_commands_class, history: true, prompt: ">", history_file_path: HISTORY_FILE_PATH)
    load_readline

    looper = Looper.new(thor_commands_class: thor_commands_class, prompt: prompt)

    if history
      History.with_history(history_file_path: history_file_path) do
        looper.run
      end
    else
      looper.run
    end
  end

  def self.load_readline
    def load_readline
      require 'readline'
      ::Readline
    rescue LoadError
      raise "Sorry, you can't use Thor REPL without Readline or a compatible library. \n" \
        "Possible solutions: \n" \
        " * Rebuild Ruby with Readline support using `--with-readline` \n" \
        " * Use the rb-readline gem, which is a pure-Ruby port of Readline \n" \
    end
  end
end

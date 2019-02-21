module ThorRepl
  class Looper
    def initialize(thor_commands_class, readline_class: Readline, welcome_message: true, prompt: ">")
      @welcome_message = welcome_message
      @readline_class = readline_class
      @thor_commands_class = thor_commands_class
      @prompt = prompt
    end

    def run
      puts "Welcome to interactive mode. Use 'help' to list available commands" if @welcome_message

      repl(-> () { @readline_class.readline(@prompt, true) }) do |input|
        args = input.split("\s")
        @thor_commands_class.start(args)
      end
    end

    private

    def repl(input_proc)
      while (input = input_proc.call)
        case input
        when /^exit!?/
          break
        when //
          Readline::HISTORY.pop
        end

        yield(input) if block_given?
      end
    end
  end
end

require "readline"

RSpec.describe ThorRepl::Looper do
  class FakeReadLine
    def initialize(inputs)
      @inputs = Array(inputs)
    end

    def readline(*args)
      return nil if @inputs.empty?
      if @inputs.first == "^C"
        @inputs.shift
        Process.kill "INT", 0
        ""
      else
        @inputs.shift
      end
    end
  end

  describe "instance methods" do
    let(:thor_class) { double(:thor_class) }
    let(:readline_class) { FakeReadLine.new(input) }
    let(:repl) do
      described_class.new(
        thor_commands_class: thor_class,
        readline_class: readline_class,
        welcome_message: false,
      )
    end

    describe "#run" do
      context "when prompt is set" do
        let(:repl) do
          described_class.new(
            thor_commands_class: thor_class,
            prompt: "funky",
            readline_class: readline_class,
            welcome_message: false,
          )
        end
        let(:input) { "exit" }

        it "passes the prompt to readline" do
          expect(readline_class).to receive(:readline).with("funky", anything)
          repl.run
        end
      end

      context "when input is exit" do
        let(:input) { "exit" }

        it "breaks without calling through" do
          expect(thor_class).not_to receive(:start)

          repl.run
        end
      end

      context "when input is exit!" do
        let(:input) { "exit!" }

        it "breaks without calling through" do
          expect(thor_class).not_to receive(:start)

          repl.run
        end
      end

      context "when input is something else" do
        let(:input) { "command --arg1=value" }

        it "it calls through" do
          expect(thor_class).to receive(:start).with(["command", "--arg1=value"])

          repl.run
        end
      end
      
      context "when input has spaces with quotes" do
        let(:input) { "command \"value1 value2\"" }

        it "it calls through" do
          expect(thor_class).to receive(:start).with(["command", "value1 value2"])

          repl.run
        end
      end

      context "when user hits Ctrl-C" do
        let(:input) { ["foo", "^C", "bar"] }

        before do
          @wrong_handler_called = false
          Signal.trap "INT" do
            @wrong_handler_called = true
          end
        end

        it "is silently trapped" do
          expect(thor_class).to receive(:start).with(["foo"])
          expect(thor_class).to receive(:start).with([])
          expect(thor_class).to receive(:start).with(["bar"])

          repl.run

          expect(@wrong_handler_called).to be_falsey
        end

        after do
          Signal.trap "INT", "SYSTEM_DEFAULT" # restore
        end
      end
    end
  end
end
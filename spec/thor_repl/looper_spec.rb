require 'readline'

RSpec.describe ThorRepl::Looper do
  class FakeReadLine
    def initialize(inputs)
      @inputs = Array(inputs)
    end

    def readline(*args)
      return nil if @inputs.empty?
      @inputs.pop
    end
  end

  describe "instance methods" do
    let(:thor_class) { double(:thor_class) }
    let(:readline_class) { FakeReadLine.new(input) }
    let(:repl) { described_class.new(thor_commands_class: thor_class, readline_class: readline_class, welcome_message: false) }


    describe "#run" do
      context "when prompt is set" do
        let(:repl) { described_class.new(thor_commands_class: thor_class, prompt: "funky", readline_class: readline_class, welcome_message: false) }
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
    end
  end
end

RSpec.describe ThorRepl::History do
  describe "#with_history" do
    let(:history) { double(:history) }
    let(:input) { "exit" }

    before do
      allow(described_class).to receive(:new).and_return(history)
    end

    it "reads and writes history" do
      expect(history).to receive(:read_history)
      expect(history).to receive(:write_history)

      described_class.with_history do
        # NOOP
      end
    end
  end

  with_temp_file("history")

  it "persists the history" do
    readline_history = ["command 1", "command 2"]
    history = described_class.new(readline_history: readline_history, history_file_path: temp_file.path)
    history.write_history
    expect(File.open(temp_file.path).readlines.map(&:chomp)).to match_array readline_history
  end

  it "reads the history" do
    readline_history = []
    File.open(temp_file.path, "w") do |f|
      f.puts "seal team six"
      f.puts "funky cold medina"
    end

    history = described_class.new(readline_history: readline_history, history_file_path: temp_file.path)
    history.read_history
    expect(readline_history).to match_array ["seal team six", "funky cold medina"]
  end
end

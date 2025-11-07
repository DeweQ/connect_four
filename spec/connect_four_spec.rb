require_relative "../lib/connect_four"

describe ConnectFour do
  describe "#add_piece" do
    context "when given correct column" do
      let(:field) do
        [[{ status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :red }],
         [{ status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :yellow }],
         [{ status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :red }],
         [{ status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :yellow }],
         [{ status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :red }],
         [{ status: :empty }, { status: :red }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :yellow }]]
      end
      let(:color) { :yellow }
      subject(:add_game) { described_class.new(field) }
      it "adds a piece on empty slot" do
        column = 0
        expect { add_game.add_piece(color, column) }.to(change { field[5][column][:status] }.from(:empty).to(color))
      end

      it "does not replace occupied slot" do
        column = 1
        expect { add_game.add_piece(color, column) }.to_not(change { field[5][column][:status] })
      end

      it "stack new piece above occupied slot" do
        column = 1
        expect { add_game.add_piece(color, column) }.to change { field[4][column][:status] }.from(:empty).to(color)
      end

      it "raise argument error when column has no empty slots" do
        column = 6
        expect { add_game.add_piece(color, column) }.to raise_error(ArgumentError, "Column overflow")
      end
    end
  end

  describe "#check_for_winner" do
    context "when game has no winner" do
      subject(:new_game) { described_class.new }
      it "returns nil" do
        expect(new_game.check_for_winner).to be_nil
      end
    end

    context "when red wins in row" do
      let(:field) do
        [[{ status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :red }],
         [{ status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :yellow }],
         [{ status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :red }],
         [{ status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :yellow }, { status: :yellow }, { status: :yellow }],
         [{ status: :empty }, { status: :empty }, { status: :empty }, { status: :red }, { status: :red }, { status: :red }, { status: :red }],
         [{ status: :empty }, { status: :red }, { status: :yellow }, { status: :red }, { status: :yellow }, { status: :red }, { status: :yellow }]]
      end
      subject(:red_won) { described_class.new(field) }

      it "returns :red" do
        expect(red_won.check_for_winner).to eq(:red)
      end
    end

    context "when yellow wins in column" do
      let(:field) do
        [[{ status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :yellow }, { status: :empty }, { status: :red }],
         [{ status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :yellow }, { status: :empty }, { status: :yellow }],
         [{ status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :yellow }, { status: :empty }, { status: :red }],
         [{ status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :yellow }, { status: :yellow }, { status: :yellow }],
         [{ status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :red }, { status: :red }, { status: :red }],
         [{ status: :empty }, { status: :red }, { status: :yellow }, { status: :red }, { status: :yellow }, { status: :red }, { status: :yellow }]]
      end
      subject(:yellow_won) { described_class.new(field) }
      it "returns :yellow" do
        expect(yellow_won.check_for_winner).to eq(:yellow)
      end
    end

    context "when red wins in diagonal" do
      let(:field) do
        [[{ status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :red }],
         [{ status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :yellow }],
         [{ status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :red }],
         [{ status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :red }, { status: :yellow }],
         [{ status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :red }, { status: :yellow }, { status: :red }],
         [{ status: :empty }, { status: :red }, { status: :yellow }, { status: :red }, { status: :yellow }, { status: :yellow }, { status: :yellow }]]
      end
      subject(:anti_diagonal) { described_class.new(field) }

      it "returns :red" do
        expect(anti_diagonal.check_for_winner).to eq(:red)
      end
    end

    context "when get diagonal over border" do
      let(:field) do
        [[{ status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }],
         [{ status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }],
         [{ status: :empty }, { status: :empty }, { status: :red }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }],
         [{ status: :empty }, { status: :red }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }],
         [{ status: :red }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }],
         [{ status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :red }]]
      end
      subject(:diagonal_game) { described_class.new(field) }

      it "rerurn nil" do
        expect(diagonal_game.check_for_winner).to be_nil
      end
    end
  end

  describe "#finished?" do
    context "when game there is no winner and field is not full" do
      let(:field) do
        [[{ status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }],
         [{ status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }],
         [{ status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }],
         [{ status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }],
         [{ status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }],
         [{ status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }]]
      end
      subject(:new_game) { described_class.new(field) }

      it "returns false" do
        expect(new_game.finished?).to be false
      end
    end

    context "when game has a winner" do
      let(:field) do
        [[{ status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :red }],
         [{ status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :yellow }],
         [{ status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :red }],
         [{ status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :red }, { status: :yellow }],
         [{ status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :red }, { status: :yellow }, { status: :red }],
         [{ status: :empty }, { status: :red }, { status: :yellow }, { status: :red }, { status: :yellow }, { status: :yellow }, { status: :yellow }]]
      end
      subject(:won_game) { described_class.new(field) }

      it "returns true" do
        expect(won_game.finished?).to be true
      end
    end

    context "when field is full and there is no winner" do
      let(:field) do
        [[{ status: :red }, { status: :red }, { status: :yellow }, { status: :yellow }, { status: :red }, { status: :red }, { status: :yellow }],
         [{ status: :yellow }, { status: :yellow }, { status: :red }, { status: :red }, { status: :yellow }, { status: :yellow }, { status: :red }],
         [{ status: :red }, { status: :red }, { status: :yellow }, { status: :yellow }, { status: :red }, { status: :red }, { status: :yellow }],
         [{ status: :yellow }, { status: :yellow }, { status: :red }, { status: :red }, { status: :yellow }, { status: :yellow }, { status: :red }],
         [{ status: :red }, { status: :red }, { status: :yellow }, { status: :yellow }, { status: :red }, { status: :red }, { status: :yellow }],
         [{ status: :yellow }, { status: :yellow }, { status: :red }, { status: :red }, { status: :yellow }, { status: :yellow }, { status: :red }]]
      end
      subject(:full_game) { described_class.new(field) }
      it "returns true" do
        expect(full_game.finished?).to be true
      end
    end
  end

  describe "#verify" do
    subject(:verify_game) { described_class.new }
    let(:min) { 0 }
    let(:max) { 7 }

    context "when given a valid input as argument" do
      let(:valid_input) { 3 }
      it "returns valid input" do
        expect(verify_game.verify(valid_input, min, max)).to eq(valid_input)
      end
    end

    context "when given invalid input" do
      let(:invalid_input) { -1 }
      it "returns nil" do
        expect(verify_game.verify(invalid_input, min, max)).to be_nil
      end
    end
  end

  describe "#player_input" do
    subject(:input_game) { described_class.new }
    let(:min) { 0 }
    let(:max) { 7 }
    let(:error_message) { "Wrong input. Please enter a number between #{min} and #{max}" }
    context "when user number is in range" do
      before do
        valid_input = "3\n"
        allow(input_game).to receive(:gets).and_return(valid_input)
      end

      it "stops loop and does not display error message" do
        expect(input_game).not_to receive(:puts).with(error_message)
        input_game.player_input(min, max)
      end
    end

    context "when user inputs an incorrect value once, then a valid input" do
      before do
        invalid_input = "asdf"
        valid_input = "3"
        allow(input_game).to receive(:gets).and_return(invalid_input, valid_input)
      end

      it "completes loop and displays error message once" do
        expect(input_game).to receive(:puts).with(error_message).once
        input_game.player_input(min, max)
      end
    end
  end
  describe "#play_round" do
    let(:field) do
      [[{ status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }],
       [{ status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }],
       [{ status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }],
       [{ status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }],
       [{ status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }],
       [{ status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }, { status: :empty }]]
    end
    subject(:round_game) { described_class.new(field) }
    before do
      allow(round_game).to receive(:gets).and_return("3")
      allow(round_game).to receive(:display)
    end

    it "changes the field" do
      expect { round_game.play_round }.to(change { field })
    end
  end
end

require_relative "../lib/connect_four"

describe ConnectFour do
  describe "#initialize" do
  end

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

    context "when given incorrect column" do
      subject(:column_game) { described_class.new }
      it "raise argument error" do
        expect { column_game.add_piece(:yellow, -1) }.to raise_error(ArgumentError, "Column out of range")
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
  end
end

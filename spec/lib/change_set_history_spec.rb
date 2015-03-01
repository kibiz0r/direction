require "spec_helper"

describe Direction::ChangeSetHistory do
  let :foo_change do
    Direction::BasicChange.new(
      Direction::HistoryConstant.new("Foo"),
      :new
    )
  end

  let :bar_change do
    Direction::BasicChange.new(
      Direction::HistoryObject.new(1),
      :do_stuff
    )
  end

  let :effects do
    []
  end

  let :foo_change_set do
    Direction::BasicChangeSet.new foo_change, effects
  end

  describe "#commit" do
    it "returns a HistoryChangeSet" do
      history_change_set = subject.commit 1, foo_change_set
      expect(history_change_set).to be_a(Direction::HistoryChangeSet)
    end

    it "stores the HistoryChangeSet at the given id" do
      history_change_set = subject.commit 1, foo_change_set
      expect(subject.find(1)).to eq(history_change_set)
    end

    it "updates the head to the given id" do
      subject.commit 1, foo_change_set
      expect(subject.head).to eq(1)
    end
  end

  describe "#branch" do
    it "returns a new history with the same change sets" do
      history_change_set = subject.commit 1, foo_change_set

      new_history = subject.branch

      expect(new_history.head).to eq(1)
      expect(new_history.find(1)).to eq(history_change_set)
    end
  end

  describe "#merge" do
    let :one_change_set do
      Direction::BasicChangeSet.new nil, nil
    end

    let :two_change_set do
      Direction::BasicChangeSet.new nil, nil
    end

    let :three_change_set do
      Direction::BasicChangeSet.new nil, nil
    end

    let :four_change_set do
      Direction::BasicChangeSet.new nil, nil
    end

    let :five_change_set do
      Direction::BasicChangeSet.new nil, nil
    end

    it "merges a history with this one, putting the other's change sets last" do
      subject.commit 1, one_change_set
      subject.commit 2, two_change_set

      other = subject.branch
      subject.commit 3, three_change_set
      other.commit 4, four_change_set
      other.commit 5, five_change_set

      subject.merge other

      expect(subject.head).to eq(5)
    end

    context "without a common ancestor" do
      it "raises an error" do
      end
    end
  end

  # describe "#rebase" do
  #   it "merges a history with this one, putting the other's change sets first" do
  #     subject.commit 1, one_change_set
  #     subject.commit 2, two_change_set
  #     other = subject.branch
  #     subject.commit 3, three_change_set
  #     other.commit 4, four_change_set
  #     other.commit 5, five_change_set
  #     subject.rebase other
  #     expect(subject.head).to eq(3)
  #   end

  #   context "without a common ancestor" do
  #     it "raises an error" do
  #     end
  #   end

  #   context "with a modified common ancestor" do
  #     it "raises an error" do
  #       subject.commit 1, one_change_set
  #       subject.commit 2, two_change_set

  #       other = subject.branch
  #       subject.commit 3, three_change_set
  #       other.amend 2, four_change_set
  #       other.commit 4, five_change_set

  #       expect { subject.rebase other }.to raise_error
  #     end

  #     context "and a conflict resolver" do
  #       it "allows resolving conflicts" do
  #         subject.commit 1, one_change_set
  #         subject.commit 2, two_change_set

  #         other = subject.branch
  #         subject.commit 3, three_change_set
  #         other.amend 2, four_change_set
  #         other.commit 4, five_change_set

  #         subject.rebase other do |conflict|
  #           conflict.resolve
  #         end
  #       end
  #     end
  #   end

  #   context "with a conflicting change" do
  #     it "raises an error" do
  #       subject.commit 1, one_change_set
  #       subject.commit 2, two_change_set
  #       other = subject.branch
  #       subject.commit 3, three_change_set
  #       other.commit 3, four_change_set
  #       other.commit 4, five_change_set
  #       expect { subject.rebase other }.to raise_error
  #     end

  #     context "and a conflict resolver" do
  #       it "allows resolving conflicts" do
  #         subject.commit 1, one_change_set
  #         subject.commit 2, two_change_set
  #         other = subject.branch
  #         subject.commit 3, three_change_set
  #         other.commit 4, four_change_set
  #         other.commit 5, five_change_set
  #         subject.rebase other
  #         expect(subject.head).to eq(3)
  #       end
  #     end
  #   end
  # end

  # describe "#to_hash" do
  #   it "returns a hash representation of the history" do
  #     expect(subject.to_hash).to eq(
  #       head: 3,
  #       change_sets: {
  #         1: Direction::ChangeSet.new(nil, []),
  #         2: Direction::ChangeSet.new(nil, []),
  #         3: Direction::ChangeSet.new(nil, [])
  #       }
  #     )
  #     # or just
  #     expect(subject.to_hash).to eq(
  #       1: Direction::ChangeSet.new(nil, []),
  #       2: Direction::ChangeSet.new(nil, []),
  #       3: Direction::ChangeSet.new(nil, [])
  #     )
  #   end
  # end

  # describe "#to_a" do
  #   it "returns an array of change sets" do
  #   end
  # end

  # describe "#revise" do
  #   it "modifies the effects of the identified change set" do
  #     subject.revise 1, new_effects
  #   end
  # end
end

require 'rails_helper'

describe Championship do

  describe '#generate_brackets!' do
    subject { FactoryGirl.create :championship }

    it 'raises an Championship::InvalidParticipantsNumber if the number of participants is not power of 2' do
      allow(subject).to receive(:participants).and_return(FactoryGirl.build_list :participant, 3)
      expect { subject.generate_brackets! }.to raise_error Championship::InvalidParticipantsNumber
    end

    it 'raises an Championship::InvalidChampionshipType if the number of participants is not power of 2' do
      allow(subject).to receive(:participants).and_return(FactoryGirl.build_list :participant, 2)
      allow(subject).to receive(:brackets?).and_return(false)
      expect { subject.generate_brackets! }.to raise_error Championship::InvalidChampionshipType
    end

    it 'generates the brackets correctly' do
      allow(subject).to receive(:brackets?).and_return(true)
      allow(subject).to receive(:participants).and_return(FactoryGirl.create_list :participant, 8, championship: subject)
      subject.generate_brackets!

      brackets = subject.brackets
      expect(brackets.count).to eq 7
      brackets.each do |bracket|
        expect(bracket.championship_id).to eq subject.id
      end

      filled_brackets = brackets.select { |bracket| bracket.player_1.present? }
      expect(filled_brackets.count).to eq 4
      filled_brackets.each_with_object([]) do |bracket, players_in_matches|
        expect(bracket.parent).to be_present

        expect(bracket.player_1).to be_in subject.participants
        expect(players_in_matches).not_to include(bracket.player_1)
        players_in_matches << bracket.player_1

        expect(bracket.player_2).to be_in subject.participants
        expect(players_in_matches).not_to include(bracket.player_2)
        players_in_matches << bracket.player_2
      end

      finals = brackets.select { |bracket| bracket.parent.blank? }
      expect(finals.count).to eq 1

      brackets.reject { |bracket| bracket.in?(finals) }.each do |not_final_bracket|
        children = brackets.select { |bracket| bracket.parent == not_final_bracket}
        expect(children.count).to eq(2).or eq(0)
      end
    end
  end

  describe '#full_loaded_final' do
    subject { FactoryGirl.create :championship }
    let!(:root) { FactoryGirl.create :bracket, championship: subject }
    let!(:first_level) { FactoryGirl.create_list :bracket, 2, championship: subject, parent: root }
    let!(:second_level) { FactoryGirl.create_list :bracket, 2, championship: subject, parent: first_level.first }

    it 'returns the final match with all the children loaded' do
      allow(subject).to receive(:brackets?).and_return(true)
      expect(Bracket).not_to receive(:where)
      expect(subject).to receive(:brackets).and_call_original

      final = subject.full_loaded_final

      expect(final).to eq root
      expect(final.children).to match_array first_level
      expect(final.children.second.children).to match_array second_level
    end
  end

end

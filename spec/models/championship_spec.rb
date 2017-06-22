require 'rails_helper'

describe Championship do
  
  describe '#full_loaded_final' do
    subject { FactoryGirl.create :championship }
    let!(:root) { FactoryGirl.create :bracket, championship: subject }
    let!(:first_level) { FactoryGirl.create_list :bracket, 2, championship: subject, parent: root }
    let!(:second_level) { FactoryGirl.create_list :bracket, 2, championship: subject, parent: first_level.first }
    
    
    before do
      allow(subject).to receive(:brackets?).and_return(true)
    end
    
    it 'returns the final match with all the children loaded' do
      expect(Bracket).not_to receive(:where)
      expect(subject).to receive(:brackets).and_call_original
      
      final = subject.full_loaded_final
      
      expect(final).to eq root
      expect(final.children).to match_array first_level
      expect(final.children.first.children).to match_array second_level
    end
  end
  
end
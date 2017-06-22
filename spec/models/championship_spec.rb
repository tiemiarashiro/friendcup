require 'rails_helper'

describe Championship do
  
  describe '#full_loaded_final' do
    subject { FactoryGirl.create :championship }
    
    
    before do
      allow(subject).to receive(:brackets?).and_return(true)

      root = FactoryGirl.create :bracket, championship: subject
      first_level = FactoryGirl.create_list :bracket, 2, championship: subject, parent: root
      FactoryGirl.create_list :bracket, 2, championship: subject, parent: first_level.first
    end
    
    it 'returns the final match with all the children loaded' do
      expect(Bracket).to receive(:where).once
      
      final = subject.full_loaded_final
      
      expect(final.children).to have(2).items
      expect(final.children.first.children).to have(2).items
    end
  end
  
end
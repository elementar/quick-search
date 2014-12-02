require 'models/active_record_test_models'

module ActiveRecordTestModels
  RSpec.describe 'when using the ActiveRecord adapter' do
    it 'should perform simple searches' do
      expect(SimpleUser.quick_search('john')).not_to be_empty
      expect(SimpleUser.quick_search('waldi')).to be_empty
    end
    it 'should perform joined searches' do
      expect(UserConfiguredWithJoins.quick_search('waldi')).not_to be_empty
    end
    it 'joined searches should not return duplicates', :pending do
      expect(UserConfiguredWithJoins.quick_search('a').size).to eq 1
    end
  end
end
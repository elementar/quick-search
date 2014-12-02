require 'models/mongoid_test_models'

module MongoidTestModels
  RSpec.describe 'when using the Mongoid adapter' do
    it 'should perform simple searches' do
      expect(SimpleUser.quick_search('john')).not_to be_empty
      expect(SimpleUser.quick_search('waldi')).to be_empty
    end
    it 'should perform searches on subdocuments' do
      expect(UserConfiguredForSubdocument.quick_search('waldi')).not_to be_empty
    end
    it 'searches on subdocuments should not return duplicates (duh)' do
      expect(UserConfiguredForSubdocument.quick_search('a').size).to eq 1
    end
  end
end
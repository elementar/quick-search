require 'quick-search'

RSpec.describe 'the method is called on an unsupported record class' do
  class PlainModel
    include QuickSearch
  end

  subject { PlainModel }

  it 'should raise an exception' do
    expect {
      subject.quick_search 'the quick brown fox'
    }.to raise_error QuickSearch::UnsupportedAdapter, /could not find an adapter for your class: PlainModel/
  end
end
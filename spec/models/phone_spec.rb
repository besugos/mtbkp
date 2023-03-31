require 'rails_helper'

RSpec.describe Phone, type: :model do
	it 'has a valid factory' do
		expect(create :phone).to be_valid
	end

	describe 'Relations' do
		it { should belong_to :phonetable }
		it { should belong_to :phone_type }
	end
end

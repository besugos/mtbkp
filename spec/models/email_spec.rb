require 'rails_helper'

RSpec.describe Email, type: :model do
	it 'has a valid factory' do
		expect(create :email).to be_valid
	end

	describe 'Relations' do
		it { should belong_to :emailtable }
		it { should belong_to :email_type }
	end
end

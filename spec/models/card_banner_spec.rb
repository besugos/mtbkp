require 'rails_helper'

RSpec.describe CardBanner, type: :model do
	it 'has a valid factory' do
		expect(create :card_banner).to be_valid
	end

	describe 'Validations' do 
		it { should validate_presence_of :name }
	end

end

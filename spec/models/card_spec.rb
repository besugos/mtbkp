require 'rails_helper'

RSpec.describe Card, type: :model do
	it 'has a valid factory' do
		expect(create :card).to be_valid
	end

	describe 'Validations' do 
		it { should validate_presence_of :name }
		it { should validate_presence_of :number }
		it { should validate_presence_of :validate_date }
	end

end

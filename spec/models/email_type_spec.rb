require 'rails_helper'

RSpec.describe EmailType, type: :model do

	describe 'Validations' do
		it { should validate_presence_of :name }
	end

	describe 'Relations' do 
	end
end

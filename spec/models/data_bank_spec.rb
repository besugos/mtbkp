require 'rails_helper'

RSpec.describe DataBank, type: :model do

	describe 'Validations' do 
		it { should validate_presence_of :bank }
		it { should validate_presence_of :agency }
		it { should validate_presence_of :account }
	end

	describe 'Relations' do
		it { should belong_to :databanktable }
	end
end

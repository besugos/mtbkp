class Room < ApplicationRecord
	belongs_to :first_participant, :class_name => 'User'
	belongs_to :second_participant, :class_name => 'User'
end

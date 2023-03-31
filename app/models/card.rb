class Card < ApplicationRecord

	attr_encrypted_options.merge!(:encode => true)
	attr_encrypted :name, :key => ENV["DB_COL_ENCRYPTED_KEY"]
	attr_encrypted :number, :key => ENV["DB_COL_ENCRYPTED_KEY"]
	attr_encrypted :ccv_code, :key => ENV["DB_COL_ENCRYPTED_KEY"]

	belongs_to :ownertable, :polymorphic => true
	belongs_to :card_banner

	attr_accessor :page_title

	validates_presence_of :name, :card_banner_id, :ccv_code, :validate_date_month, :validate_date_year

	validates :number, credit_card_number: true, if: Proc.new { |object| !object.number.nil? && !object.number.blank? }

	scope :by_ownertable_type, lambda { |value| where(ownertable_type: value) if !value.nil? && !value.blank? }
	
	scope :by_ownertable_id, lambda { |value| where(ownertable_id: value) if !value.nil? && !value.blank? }

	def self.get_months
		return ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12']
	end

	def self.get_years
		array = []
		current_year = Date.today.strftime('%Y').to_i
		(current_year..(current_year+15)).each do |i|
			array.push(i)
		end
		return array
	end

	def get_formatted_name
		result = ''
		if !self.number.nil?
			result_strip = self.number.gsub(/\s+/, "")
			result = '**** **** **** '
			if !result_strip[12].nil?
				result += result_strip[12]
			end
			if !result_strip[13].nil?
				result += result_strip[13]
			end
			if !result_strip[14].nil?
				result += result_strip[14]
			end
			if !result_strip[15].nil?
				result += result_strip[15]
			end
		end
		return result
	end

	def get_formatted_validate_date
		result = ''
		if !self.validate_date_month.nil?
			result += self.validate_date_month
		end
		if !self.validate_date_year.nil?
			result += '/'+self.validate_date_year
		end
		return result
	end

end


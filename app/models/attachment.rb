class Attachment < ActiveRecord::Base
	
	before_create :save_attachment
	attr_accessor :attachment_url

	belongs_to :ownertable, :polymorphic => true

	has_one_attached :attachment

	# has_attached_file :attachment,
	# :storage => :s3,
	# :url => ":s3_domain_url",
	# styles: { medium: "300x300#", thumb: "100x100#", select: "50x50#" },
	# :path => ":class/attachment/:id_partition/:style/:filename"
	# do_not_validate_attachment_file_type :attachment

	# validates_attachment_content_type :attachment, content_type: /\Aimage\/.*\z/
	# default_url: "/images/:style/missing.png"

	def is_video?
		attachment.instance.attachment_content_type =~ %r(video)
	end

	def is_image?
		attachment.instance.attachment_content_type =~ %r(image)
	end

	def is_audio?
		attachment.instance.attachment_content_type =~ %r(audio)
	end

	def get_url_image
		result = nil
		if self.attachment.attached?
			result = self.attachment.url
		end
		return result
	end

	def get_image
		result = ""
		if !self.attachment.attached?
			result = "https://via.placeholder.com/300x300"
		else
			result = self.attachment.url
		end
		return result
	end

	private

	def save_attachment
		if !self.attachment_url.nil? && !self.attachment_url.blank?
			require 'uri'
			if self.attachment_url =~ URI::regexp
				self.attachment = URI.parse(self.attachment_url).open
			end
		end
	end
	
end

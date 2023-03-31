class AttachmentSerializer < ActiveModel::Serializer

	attributes :id, :attachment_type

	attribute :attachment_file_name do
		if !object.nil? && object.attachment.attached?
			object.attachment.filename
		end
	end

	attribute :attachment_url do
		if !object.nil? && !object.attachment.nil?
			url_for(object.attachment)
		end
	end

end  
class SystemConfigurationSerializer < ActiveModel::Serializer

	attributes :id,
	:notification_mail,
	:use_policy,
	:exchange_policy,
	:warranty_policy,
	:privacy_policy,
	:phone,
	:cellphone,
	:data_security_policy,
	:quality,
	:about,
	:mission,
	:view,
	:values,
	:site_link,
	:facebook_link,
	:instagram_link,
	:twitter_link

	attribute :client_logo_url do
		if !object.client_logo.nil? && !object.client_logo.attached?
			object.client_logo.url
		end
	end


end  
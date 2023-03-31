class SystemConfigurationsController < ApplicationController

    def edit
        authorize SystemConfiguration
        build_initials_relations
    end

    def update
        authorize SystemConfiguration
        @system_configuration.update(system_configuration_params)
        if @system_configuration.valid?
            flash[:success] = t('flash.update')
            redirect_to edit_system_configuration_path(1)
        else
            flash[:error] =  @system_configuration.errors.full_messages.join('<br>')
            build_initials_relations
            render :edit
        end
    end

    def build_initials_relations
        @system_configuration.build_address(address_area_id: AddressArea::GENERAL_ID) if @system_configuration.address.nil?    
    end

    private

    def system_configuration_params
        params
        .require(:system_configuration)
        .permit(:notification_mail, 
            :contact_mail,
            :privacy_policy,
            :use_policy,
            :warranty_policy,
            :exchange_policy,
            :phone,
            :cellphone,
            :data_security_policy,
            :quality,
            :about,
            :about_image,
            :about_video_link,
            :mission,
            :view,
            :values,
            :site_link,
            :facebook_link,
            :linkedin_link,
            :instagram_link,
            :twitter_link,
            :youtube_link,
            :client_logo,
            :cnpj,
            :id_google_analytics,
            :page_title,
            :page_description,
            :favicon,
            :geral_conditions,
            :contract_data,
            :attendance_data,
            :plan_name,
            :plan_price,
            :plan_description,
            :professional_contact_phone,
            :client_contact_phone,
            :professional_contact_mail,
            :client_contact_mail,
            :percent_order_products,
            :maximum_installments,
            :maximum_installment_plans,
            :footer_text,
            :footer_image,
            :size_banner_image,
            :size_banner_image_mobile,
            :client_cellphone,
            :professional_cellphone,
            :size_banner_link,
            address_attributes: [ :id, :latitude, :longitude, :page_title, :address_type_id, :address_area_id, :name, :zipcode, :address, :district, :number, :complement, :address_type, :state_id, :city_id, :country_id, :reference])
    end

end
<%- module_namespacing do -%>
class <%= class_name %> < <%= parent_class_name.classify %>
  after_initialize :default_values

  scope :by_id, lambda { |value| where("id = ?", value) if !value.nil? && !value.blank? }

  <%- attributes.select(&:reference?).each do |attribute| -%>
  belongs_to :<%= attribute.name %><%= ', polymorphic: true' if attribute.polymorphic? %><%= ', required: true' if attribute.required? %>
  <%- end -%>
  <%- attributes.select(&:token?).each do |attribute| -%>
    has_secure_token<%- if attribute.name != "token" -%> :<%= attribute.name %><%- end -%>
  <%- end -%>
  <%- if attributes.any?(&:password_digest?) -%>
  has_secure_password
  <%- end -%>
  
  def get_text_name
    self.id.to_s
  end

  private

  def default_values
  end

end
<%- end -%>

# Be sure to restart your server when you modify this file.

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
ApplicationHelper::API_MIME_TYPE_CONFIG.each do |mime_type|
  primary = mime_type.shift
  alternatives = mime_type

  Mime::Type.register primary[1], primary[0], alternatives.values, alternatives.keys
end

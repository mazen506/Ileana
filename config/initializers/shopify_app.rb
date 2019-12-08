ShopifyApp.configure do |config|
	if Rails.env == 'production'
		puts "Starting Shopify app in production mode."
		# Production configuration
    config.application_name = "ILEANA"
    config.api_key = "9d8bf20b85084b028404278cfa8b59f3"
    config.secret = "0111b57df967fef0a14fa1bc3f602b17"
		config.scope = "read_products, write_products, read_orders, write_orders, read_customers, read_themes, write_themes, read_gift_cards, write_gift_cards"
		config.api_version = "2019-10"
		config.embedded_app = true
		config.after_authenticate_job = false
		config.session_repository = Shop
	else
		puts "Starting Shopify app in development mode."
		# Development configuration
    config.application_name = "ILEANA"
    config.api_key = "9d8bf20b85084b028404278cfa8b59f3"
    config.secret = "0111b57df967fef0a14fa1bc3f602b17"
		config.scope = "read_products, write_products, read_orders, write_orders, read_customers, read_themes, write_themes, read_gift_cards, write_gift_cards" 
		config.api_version = "2019-10"
		config.embedded_app = true
		config.after_authenticate_job = false
		config.session_repository = Shop
	end
end
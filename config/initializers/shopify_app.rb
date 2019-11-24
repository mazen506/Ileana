ShopifyApp.configure do |config|
  config.application_name = "ILEANA"
  config.api_key = "9d8bf20b85084b028404278cfa8b59f3"
  config.secret = "0111b57df967fef0a14fa1bc3f602b17"
  config.old_secret = ""
  config.scope = "read_products, read_orders, write_orders, read_customers, read_themes, write_themes, read_gift_cards, write_gift_cards"
                                 # https://help.shopify.com/en/api/getting-started/authentication/oauth/scopes
  config.embedded_app = true
  config.after_authenticate_job = false
  config.api_version = "2019-10"
  config.session_repository = Shop
end

# ShopifyApp::Utils.fetch_known_api_versions                        # Uncomment to fetch known api versions from shopify servers on boot
# ShopifyAPI::ApiVersion.version_lookup_mode = :raise_on_unknown    # Uncomment to raise an error if attempting to use an api version that was not previously known

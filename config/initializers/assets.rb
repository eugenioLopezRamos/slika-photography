# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

Rails.application.config.assets.precompile += %w( script-main.js jquery.js jquery_ujs.js )
Rails.application.config.assets.precompile += %w( style-main.scss.erb )
Rails.application.config.assets.precompile += %w( file-manager.js )

Rails.application.config.assets.precompile += %w( admin.scss )
Rails.application.config.assets.precompile += %w( file-manager.scss )
#Rails.application.config.assets.precompile += %w( jquery.js )
#Rails.application.config.assets.precompile += %w( jquery_ujs.js )
Rails.application.config.assets.precompile =  ['*.js', '*.css', '*.scss']
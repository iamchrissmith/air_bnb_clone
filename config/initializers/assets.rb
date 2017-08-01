# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w( reservations/submit.js
                                                  search/homeSearch.js
                                                  maps/searchMap.js
                                                  admin/dashboard/charts/owner_most_revenue.js
                                                  admin/dashboard/charts/reservations_by_month.js
                                                  admin/dashboard/charts/user_most_spent.js
                                                  admin/dashboard/charts/user_most_bookings.js
                                                  admin/dashboard/charts/user_most_nights.js
                                                  admin/dashboard/maps/us-states.js )

# this does not work with heroku in production. the haml engine is not loaded during
# asset precompile. it works fine for development mode, and production when
#     config.assets.initialize_on_precompile = true

# enable compiling .html assets
# Rails.application.assets.register_engine '.haml', Tilt::HamlTemplate

# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_RisingGuilds_session',
  :secret      => '26ab4fe6fd50c3dda0d2525bf39254b429f08cea148d7d201c5c155ddaff3f711ba28d749f97dc686f26d1d779a01ce5814511cba9615d016c2a1a70fbd8490f'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store

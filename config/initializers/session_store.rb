# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_mailnix_session',
  :secret      => '1c029058b997ce3fe80631cf20143fa965b23978969bcb9dac1bf794fdcfb836c72e701decb3071528cc73122a72f994e2538720b917767c6c5dce11c65d2b84'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store

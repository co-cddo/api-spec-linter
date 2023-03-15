Rails.application.config.session_store :active_record_store, key: "cddo-linter-session", expire_after: 48.hours.to_i
ActiveRecord::SessionStore::Session.serializer = :json

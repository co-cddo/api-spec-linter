class << self
  def session_store
    Rails.application.config.session_store :active_record_store,
      key: 'cddo-linter-session', expire_after: 20.minutes.to_i
    ActiveRecord::SessionStore::Session.serializer = :json
  end
end

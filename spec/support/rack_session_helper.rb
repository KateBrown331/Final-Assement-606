module RackSessionHelper
  def login(user)
    # Set the session using rack_session_access
    post "/__rack_session", params: { rack_session: { user_id: user.id } }
  end
end

RSpec.configure do |config|
  config.include RackSessionHelper, type: :request
end

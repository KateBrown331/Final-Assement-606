Rails.application.config.after_initialize do
  if Rails.env.development?
    begin
      config_am = Rails.application.config.action_mailer
      if config_am.nil?
        Rails.application.config.action_mailer = ActiveSupport::OrderedOptions.new
        config_am = Rails.application.config.action_mailer
      end

      config_am.smtp_settings ||= {}
      config_am.smtp_settings[:openssl_verify_mode] = "none"
    rescue => e
      warn "disable_global_ssl_verification: failed to set ActionMailer smtp_settings: #{e.class}: #{e.message}"
    end
  end
end

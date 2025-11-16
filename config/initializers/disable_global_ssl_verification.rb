Rails.application.config.after_initialize do
  if Rails.env.development?
    begin
      if defined?(ActionMailer::Base)
        ActionMailer::Base.smtp_settings ||= {}
        ActionMailer::Base.smtp_settings[:openssl_verify_mode] = 'none'
      end
    rescue => e
      warn "disable_global_ssl_verification: failed to set ActionMailer smtp_settings: #{e.class}: #{e.message}"
    end
  end
end

ActionMailer::Base.default_url_options[:host] = configatron.notifier.default_url
ActionMailer::Base.smtp_settings[:enable_starttls_auto] = false
Mail.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development? && !Rails.env.test?
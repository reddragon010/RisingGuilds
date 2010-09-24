ActionMailer::Base.default_url_options[:host] = configatron.notifier.default_url
Mail.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?
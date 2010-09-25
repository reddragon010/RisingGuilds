class DevelopmentMailInterceptor
  def self.delivering_email(message)
    unless Rails.env.cucumber?
      message.subject = "#{message.to} #{message.subject}"
      message.to = "webmaster@dreamblaze.net"
    end
  end
end
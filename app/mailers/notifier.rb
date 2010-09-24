class Notifier < ActionMailer::Base
  default :from => "RisingGuilds Notifier <noreply@dreamblaze.net>"
  
  def password_reset_instructions(user)
    @edit_password_reset_url = edit_password_reset_url(user.perishable_token)
    mail(:subject => "Password Reset Instructions",:to => user.email)
    user.reset_perishable_token!  
  end
  
  def activation_instructions(user)
    @account_activation_url = register_url(user.perishable_token)
    mail(:subject => "Activation Instructions",:to => user.email)
    user.reset_perishable_token!
  end

  def activation_confirmation(user)
    @root_url = root_url
    mail(:subject => "Activation Complete",:to => user.email)
    user.reset_perishable_token!
  end
end

module RaidsHelper

  def approve_style_helper(approved)
    if approved
      return "color:green;"
    else
      return "color:red;"
    end
  end

end

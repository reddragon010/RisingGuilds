class HomeController < ApplicationController
  add_breadcrumb "Home", :root_path
  
  def index
    add_breadcrumb "", :root_path
  end

end

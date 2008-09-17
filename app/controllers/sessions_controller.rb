# This controller handles the login/logout function of the site.
class SessionsController < ApplicationController
  # render new.rhtml
  def new
  end

  def create
    self.current_user = User.authenticate(params[:login], params[:password])
    flash[:error] = "invalid username/password" unless logged_in?
    rerender()
  end

  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    @current_user = nil
    session[:logout_message] = true
    redirect_to :controller => "sidebar_links", :action => "index"
  end

  protected

  def rerender
    render :update do |page|
      if params[:goto]
        page.redirect_to("/#{params[:goto][:controller]}/#{params[:goto][:action]}")
      else
        page.redirect_to("")
      end
    end
  end
end

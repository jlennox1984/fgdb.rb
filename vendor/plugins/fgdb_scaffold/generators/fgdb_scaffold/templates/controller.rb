class <%= controller_class_name %>Controller < ApplicationController
  layout :with_sidebar

  def index
    @<%= table_name %> = <%= class_name %>.find(:all)
  end

  def show
    @<%= file_name %> = <%= class_name %>.find(params[:id])
  end

  def new
    @<%= file_name %> = <%= class_name %>.new
  end

  def edit
    @<%= file_name %> = <%= class_name %>.find(params[:id])
  end

  def create
    @<%= file_name %> = <%= class_name %>.new(params[:<%= file_name %>])

    if @<%= file_name %>.save
      flash[:notice] = '<%= class_name %> was successfully created.'
      redirect_to({:action => "show", :id => @<%= file_name %>.id})
    else
      render :action => "new"
    end
  end

  def update
    @<%= file_name %> = <%= class_name %>.find(params[:id])

    if @<%= file_name %>.update_attributes(params[:<%= file_name %>])
      flash[:notice] = '<%= class_name %> was successfully updated.'
      redirect_to({:action => "show", :id => @<%= file_name %>.id})
    else
      render :action => "edit"
    end
  end

  def destroy
    @<%= file_name %> = <%= class_name %>.find(params[:id])
    @<%= file_name %>.destroy

    redirect_to({:action => "index"})
  end
end

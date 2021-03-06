class CustomizationsController < ApplicationController
  layout "skedjulnator"
  protected
  def get_required_privileges
    a = super
    a << {:privileges => ['skedjulnator']}
    a
  end
  public

  before_filter :update_skedjulnator_access_time

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @customizations = Customization.paginate :per_page => 10, :page => params[:page]
  end

  def show
    @customization = Customization.find(params[:id])
  end

  def new
    @customization = Customization.new
  end

  def create
    @customization = Customization.new(params[:customization])
    if @customization.save
      flash[:notice] = 'Customization was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @customization = Customization.find(params[:id])
  end

  def update
    @customization = Customization.find(params[:id])
    if @customization.update_attributes(params[:customization])
      flash[:notice] = 'Customization was successfully updated.'
      redirect_to :action => 'show', :id => @customization
    else
      render :action => 'edit'
    end
  end

  def destroy
    Customization.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end

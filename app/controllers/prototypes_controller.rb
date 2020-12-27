class PrototypesController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :set_prototype, except: [:index, :new, :create]
  before_action :contributor_confirmation, only: [:edit, :update, :destroy]
 
  def index
     @prototypes = Prototype.includes(:user)
  end

  def new
    @prototype = Prototype.new

  end

  def create
     @prototype = Prototype.new(prototype_params)
    if @prototype.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show 
    @comment = Comment.new
    @comments = @prototype.comments
   end

  def edit
  end

  def update
    @prototype.update(prototype_params)
    if @prototype.update(prototype_params)
      redirect_to prototype_path(@prototype.id)
    else
      render :edit
    end
  end

  def destroy
    @prototype.destroy
    redirect_to prototypes_path
  end

  private
  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end

  def set_prototype
    @prototype = Prototype.find(params[:id])
  end

  def contributor_confirmation
    redirect_to root_path unless current_user == @prototype.user
  end
end

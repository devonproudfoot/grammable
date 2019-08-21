class GramsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def index
    @grams = Gram.all
  end

  def new
    @gram = Gram.new
  end

  def create
    @gram = current_user.grams.create(gram_params)
    if @gram.invalid?
      return render :new, status: :unprocessable_entity
    else
      redirect_to root_path
    end
  end

  def show
    @gram = Gram.find_by_id(params[:id])
    render_not_found if @gram.blank?
  end

  def edit
    @gram = Gram.find_by_id(params[:id])
    render_not_found if @gram.blank?
  end


  private

  def gram_params
    params.require(:gram).permit(:message)
  end

  def render_not_found
    render plain: "Not found!", status: :not_found
  end

end

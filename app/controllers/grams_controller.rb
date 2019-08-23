class GramsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy, :edit, :update]

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
    render_not_found if current_gram.blank?
  end

  def edit
    return render_not_found if current_gram.blank?
    return render_forbidden if current_user != current_gram.user
  end

  def update
    return render_not_found if current_gram.blank?
    return render_forbidden if current_user != current_gram.user
    
    current_gram.update_attributes(gram_params)
    if current_gram.valid?
      redirect_to gram_path(current_gram)
    else
      return render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    return render_not_found if current_gram.blank?
    return render_forbidden if current_user != current_gram.user
    current_gram.destroy
    redirect_to root_path
  end

  private

  def gram_params
    params.require(:gram).permit(:message)
  end

  def render_not_found
    render plain: "Not found!", status: :not_found
  end

  helper_method :current_gram
  def current_gram
    @gram ||= Gram.find_by_id(params[:id])
  end

  def render_forbidden
    render plain: "Forbidden", status: :forbidden
  end

end

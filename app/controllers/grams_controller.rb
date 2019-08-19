class GramsController < ApplicationController

  def index
    @grams = Gram.all
  end

  def new
    @gram = Gram.new
  end

  def create
    @gram = Gram.create(gram_params)
    if @gram.invalid?
      return render :new, status: :unprocessable_entity
    else
      redirect_to root_path
    end
  end

  private

  def gram_params
    params.require(:gram).permit(:message)
  end

end

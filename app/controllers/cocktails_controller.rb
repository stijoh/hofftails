class CocktailsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index, :show ]
  def index
    @cocktails = Cocktail.all
    @search = params['search_form']
      if @search.present?
        @term = @search['search_term']
        @cocktails = Cocktail.search(@term)
      end
  end

  def new
    @cocktail = Cocktail.new
    @cocktail.doses.build
  end

  def show
    @cocktail = Cocktail.find(params[:id])
  end

  def create
    @cocktail = Cocktail.new(cocktail_params)
    @cocktail.user = current_user
    if @cocktail.save
      redirect_to cocktail_path(@cocktail)
    else
      render 'new'
    end
  end

  def update
    @cocktail = Cocktail.find(params['id'])
    if params["cocktail"].nil?
      # removes bug if the update button is selected without any ingredients
      return render :show
    end
    @cocktail.update(cocktail_params)
    redirect_to cocktail_path(@cocktail)
  end

  private

  def cocktail_params
    params.require(:cocktail).permit(
      :name, :photo, doses_attributes: %i[id description ingredient_id _destroy]
    )
  end

  def search_params
    params.require(:search_form).permit(:search_term)
  end
end

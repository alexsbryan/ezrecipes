require 'open-uri'

class RecipesController < ApplicationController

  def index


  end

  def create
    recipe_html_string = open(params[:recipe]).read
    recipe = Hangry.parse(recipe_html_string)
    rec = {}
    recipe.each_pair do |attr, val|
      rec[attr] = val
    end
    @rec = Recipe.new(rec)

    if @rec.ingredients.nil?
      flash.now[:errors] = "Sorry, we're still working to get that site added"
      render "index"
    else
      @ingredients = @rec.ingredients.map {|x| x.gsub("\r\n","").strip}
      @instructions = @rec.instructions
      @scale = params[:quantity].to_f
      # @recipe = @recipe.recipe
      render "show"
    end

  end

  def show

  end

  #   def show
  #
  #
  #   end
  #
  #   def destroy
  #
  #
  #   end
end

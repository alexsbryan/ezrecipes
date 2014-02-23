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
    @ingredients = @rec.ingredients.map {|x| x.gsub("\r\n","").strip}
    @instructions = @rec.instructions
    # @recipe = @recipe.recipe

    render "show"
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

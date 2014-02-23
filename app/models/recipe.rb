require 'open-uri'
require 'fractional'
#TODO: make compatible with pinterest recipes. Ideally add ability to copy and paste recipe text.

class Recipe < ActiveRecord::Base

  attr_accessor :final_instructions, :instruction_array, :replaced_words

  # def initialize(url)
  #   recipe_html_string = open(url).read
  #   recipe = Hangry.parse(recipe_html_string)
  #   @recipe = recipe
  #   @ingredients = recipe.ingredients.map {|x| x.gsub("\r\n","").strip}
  #   @instructions = recipe.instructions
  #   @instruction_array = Recipe.make_instruction_array(@instructions)
  #   @replaced_words = []
  #   @final_instructions = recipe.instructions
  # end


  def interpolate_into_recipe(amt,ing,unit)

    make_instruction_array
    ini_final_instructions

    amount = amt
    ingredient = ing
    unit = unit
    ing_to_check_arr = ingredient.split(' ')

    ingred = ing.split.join(" ")

    if !self.instructions.scan(/#{ingred}/i).empty?
      chosen_word = ingred
    else

      possibilities = []

      ing_to_check_arr.each do |ing|
        possibilities = self.instruction_array.select {|wrd| wrd==ing}
      end

      possibilities = possibilities.keep_if{|ingred_word| !self.replaced_words.include?(ingred_word)} unless self.replaced_words.nil?

      #select the most common element

      chosen_word = possibilities.group_by { |e| e }.values.max_by(&:size)

      if chosen_word.nil?
        return
      else
        chosen_word = chosen_word.first
      end

    end

    if amt == 0
      amt= ''
    else
      amt = create_fraction(amount)
    end


    if unit.nil?
      replacement = amt + ' ' + chosen_word
    else
      replacement = amt + ' ' + unit.to_s.pluralize(amt.to_i) + ' ' + chosen_word
    end

    self.final_instructions.gsub!(chosen_word, replacement)
    self.replaced_words = self.replaced_words.to_a

    chosen_word.split.each {|wrd| self.replaced_words << wrd}

  end

  def make_instruction_array
    no_punct_instructions = self.instructions.downcase.gsub(/[^a-z\^1-9\s]/, '')
    @instruction_array = no_punct_instructions.split(' ')
  end

  def ini_final_instructions
    self.final_instructions = self.instructions if self.final_instructions.nil?
  end

  def create_fraction(num)
    f = Fractional.new(num).to_f
    if f%1 != 0
      return Fractional.new(f).to_s(mixed_number: true)
    else
      return f.to_i.to_s
    end

  end

end

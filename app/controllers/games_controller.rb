require "open-uri"

class GamesController < ApplicationController
  VOWELS = %w(A E I O U Y)

  def new
    @letters = Array.new(5) { VOWELS.sample }
    @letters += Array.new(5) { (('A'..'Z').to_a - VOWELS).sample }
    @letters.shuffle!
  end

  def score
    @letters = params[:letters].split # weil params letters als string hält
    @word = params[:word].upcase # instance variable word wird aus params gezogen
    @included = included?(@word, @letters) # sind die @letters in @word?
    @english_word = english_word?(@word) # api call um zu checken ob es ein echtes word ist
  end

  private

  def included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found'] # was bedeutet das found hier?
  end
end

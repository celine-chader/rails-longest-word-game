require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = ('A'..'Z').to_a.shuffle[1..10]
  end

  def score
    @answer = params[:answer]
    @letters = params[:letters]
    @message =
      if included?(@answer, @letters)
        if english_word?(@answer)
          'Congratulations'
        else
          "Sorry but #{@answer.upcase} is not an english word"
        end
      else
        "Sorry but #{@answer.upcase} can't be built out of #{@letters}."
      end
  end

  def included?(word, letters)
    array_word = word.upcase.split('')
    answer_included = true
    array_word.each do |letter|
      answer_included = false if letters.count(letter) < array_word.count(letter)
    end
    answer_included
  end

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end

require 'json'

module Word
  def word_getter
    lines = File.open('words.txt', 'r') { |words| words.readlines }
    word = lines.sample[0..-2]
  end
end

module Lives
  def get_lives
    lives = 6
  end
end

module Dash
  def dash(_word)
    dashboard = []
    (0...@word.length).each do |_i|
      line = '_'
      dashboard << line
    end
    puts dashboard.join(' ')
    dashboard
  end
end

module Alerts
  def notify
    puts "\nYou can type 'save' to save the status of the game."
    puts "Enter your guess:"
  end

  def left(lives)
    puts "Wrong! #{lives} lives left."
  end

  def congrats
    puts 'Good job, that was impressive.'
  end

  def over
    puts 'Game Over.'
  end

  def saved
    puts "\nSuccessfully saved."
  end
end

module Saveable
  def save?(input)
    input == "save" ? true : false
  end

  def save(word, dashboard, lives)
    savefile = File.open("savefile.json", "w")
    savings = {
        word: word,
        dashboard: dashboard,
        lives: lives
    }
    savefile.write(savings.to_json)
    savefile.close
  end

  def play_saved?
    puts "Play a saved game? (y/n)"
    input = gets.downcase.chomp
    if input == 'y'
      savefile = File.read('savefile.json')
      data = JSON.parse(savefile)
      @dashboard = data['dashboard']
      @lives = data['lives']
      @word = data['word']
      puts dashboard.join(' ')
    end
  end

end

class Hangman
  include Word, Dash, Lives, Alerts, Saveable
  attr_accessor :word, :dashboard, :lives

  def initialize
    @word = word_getter
    @dashboard = dash(word)
    @lives = get_lives
    play_saved?
  end

  def play
    letters = @word.split('')
    while lives > 0
        notify
        input = gets.downcase.chomp
      if save?(input)
        save(word, dashboard, lives)
        saved
      elsif letters.include?(input)
        letters.each_with_index do |letter, index|
          dashboard[index] = letter if letter == input
        end
        puts dashboard.join(' ')
      else
        @lives -= 1
        left(lives)
        puts dashboard.join(' ')
      end
    end
    word == dashboard.join('') ? congrats : over
  end
end

game = Hangman.new
game.play

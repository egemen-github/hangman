# Game class.
class Hangman
  attr_accessor :w, :letters, :dash, :lives

  def initialize
    @w = ''
    @lives = 6
    @letters = ''
    @dash = ''
  end

  dash = []
  lives = 6

  def self.a_word
    lines = File.open('words.txt', 'r') { |words| words.readlines }
    lines.sample[0..-2]
  end

  def self.put_lines_in_dash(dash, length)
    (0...length).each do |_i|
      line = '_'
      dash << line
    end
  end

  def self.placement(dash, input, letters)
    letters.each_with_index do |letter, index|
      dash[index] = letter if letter == input
    end
  end

  def self.complete?(dash, w)
    w == dash.join('')
  end

  p w = a_word
  length = w.length
  put_lines_in_dash(dash, length)
  letters = w.split('')

  while lives > 1
    input = gets.downcase.chomp
    if letters.include?(input)
      placement(dash, input, letters)
      puts dash.join(' ')
    else
      lives -= 1
      puts "Wrong! #{lives} lives left."
    end
    puts 'You got all the letters right, that was impressive.' if complete?(dash, w)
  end
  puts 'Game over.'
end

Hangman.new

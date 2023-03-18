module Saving

  # Save the class variable
  def save_game(time = Time.now.strftime("%d-%m-%Y %H-%M"))
    # first check if the directory is already there, if not created it
    Dir.mkdir('saves') unless Dir.exist?('saves')
    
    # create a base config file, for "reset" games if the file doesn't exist.
    unless Dir.entries('saves').include?("base_config")
      File.open("./saves/base_config", 'wb') { |f| f.write(Marshal.dump(self))}
    end

    # ok, now serialize the class itself, and save it to the directory save file
    File.open(Dir.pwd + "/saves/#{time}", 'wb') { |f| f.write(Marshal.dump(self))}
  end

  # method to load the file data.
  def load_game(files = Dir.entries('saves').reject { |f| f.include?('.') || f.include?('base')}, num = -1)
    puts 'Here are the current saved files'
    files.each { |f| p "#{num += 1}: #{f}"}

    file = Marshal.load(File.binread("saves/#{file_num(files)}"))

    loaded_game(file)
  end

  def loaded_game(file)
    self.age = file.age
    self.breed = file.breed
    self.desu = file.desu
  end

  private

  # check which file from the saves files to load
  def file_num(files)
    puts 'which would you like to load?, selection base on the number ex: 0 would load the first file.'
    answer = gets.chomp
    until check_answer(answer, files)
      puts 'try again, not valid'
      answer = gets.chomp
    end
    files[answer.to_i]
  end

  # check if file exist in the array and if the answer are numbers
  def check_answer(answer, files)
    return true if answer =~ /\A\d+\Z/ && files[answer.to_i]
  end

end


class Test

  include Saving

  attr_accessor :age, :breed, :desu

  def initialize
    @age = 44
    @breed = 'nort america'
    @desu = 'desua'
  end

end

new_test = Test.new
new_test.save_game

new_test.load_game

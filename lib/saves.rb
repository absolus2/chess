# module to save the chess game
module Saving
  def save_base
    Dir.mkdir('saves') unless Dir.exist?('saves') 
    # create a base config file, for "reset" games if the file doesn't exist.
    return if Dir.entries('saves').include?('base_config')

    File.open('./saves/base_config', 'wb') { |f| f.write(Marshal.dump(self))}
  end

  # Save the class variable
  def save_game(time = Time.now.strftime('%d-%m-%Y %H-%M'))
    # first check if the directory is already there, if not created it
    # ok, now serialize the class itself, and save it to the directory save file
    File.open(Dir.pwd + "/saves/#{time}", 'wb') { |f| f.write(Marshal.dump(self)) }

    puts 'The game has been save successfully'
  end

  # method to load the file data.
  def load_game(files = Dir.entries('saves').reject { |f| f.include?('.') || f.include?('base')}, num = -1)
    puts 'Here are the current saved files'
    files.each { |f| p "#{num += 1}: #{f}"}

    file = Marshal.load(File.binread("saves/#{file_num(files)}"))

    loaded_game(file)
  end

  def loaded_game(file)
    self.board = file.board
    self.board_hash = file.board_hash
    self.turn = file.turn
    self.player_turn = file.turn
    self.player = file.player
    self.last_move_piece = file.last_move_piece
    self.moves = file.moves
    puts 'file loaded succesfully'
  end

  # check to see if the directory exist and if so, also check for files

  def check_loads
    load_not = load_files? if Dir.exist?('./saves') && Dir.entries('./saves').length > 3

    return if load_not != 'y'

    load_game
  end

  def load_files?
    puts "\nHello, we detected saved games!"
    puts 'Would you like to load one? (y/n)'
    gets.chomp
  end

  def reset_game(file = Dir.entries('./saves').select! { |f| f.include?('base') }.first)
    load_f = Marshal.load(File.binread("saves/#{file}"))

    loaded_game(load_f)
    play
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

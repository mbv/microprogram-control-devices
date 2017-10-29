class Compiler
  COMMANDS = {
      'LOAD' => '0000',
      'STORE' => '0001',
      'ADD' => '0010',
      'SUB' => '0011',
      'INC' => '0100',
      'DEC' => '0101',
      'JNZ' => '0110',
      'JZ' => '0111',
      'JNSB' => '1000',
      'JMP' => '1001',
      'HALT' => '1010',
  }

  REGEXP = /(LOAD|STORE|ADD|SUB|INC|DEC|JNZ|JZ|JNSB|JMP|HALT)[ ]*(\d+)*(( --[!]* )*(.*))/



  def run
    commands = File.readlines('program.txt')
    i = 0
    commands.each do |c|
      r = REGEXP.match c
      next if r.nil?
      command = r[1]
      command_encoded = COMMANDS[command]
      address = r[2]
      comment = r[5]

      address = '111111' unless address
      print "\"#{command_encoded}\" & \"#{address}\", -- #{i.to_s(2).rjust(6, '0')} | #{i.to_s(16).rjust(2, '0')} | #{command} #{comment}"
      puts
      i+=1
    end

  end
end


Compiler.new.run
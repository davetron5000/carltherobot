class Solution < ActiveRecord::Base
  belongs_to :player
  belongs_to :level
  serialize :code, Array

  COMMAND_NAMES = Command::KNOWN_COMMANDS.map(&:command_name)

  def parse_code(code)
    @control_names ||= {}
    Command::CONTROL_COMMANDS.each { |klass| @control_names[klass.command_name] = klass }
    real_code = []
    count = 0
    while count < code.size
      loc = code[count]
      command,args = loc.split(/\s/,2).map(&:strip)
      if COMMAND_NAMES.include? command
        if @control_names[command]
          count,code_block = parse_control_block(code,count)
          command = @control_names[command].new(args,code_block)
          real_code << command
        else
          real_code << command
        end
      else
        raise "Unknown command #{loc} on line #{count}"
      end
      count += 1
    end
    self.code = real_code
  end

  def parse_control_block(code,count)
    code_block = []
    count += 1
    while code[count] != 'end'
      return [count,nil] if code[count].nil? || count > code.length
      loc = code[count]
      command,args = loc.split(/\s/,2).map(&:strip)
      if @control_names[command]
        count,inner_code_block = parse_control_block(code,count)
        command = @control_names[command].new(args,inner_code_block)
        code_block << command
      else
        code_block << command
      end
      count += 1
    end
    [count,code_block]
  end
end

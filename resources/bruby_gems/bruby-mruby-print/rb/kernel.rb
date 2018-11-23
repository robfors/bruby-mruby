module Kernel

  # we override this because the default behavior is to print out an extra new line for every line
  #  however this only started happening recently, when I moved the interpreter to extranEouS
  # this method will hopefully only be temporary
  def __printstr__(string_rb)
    raise TypeError, "can only print a String" unless string_rb.is_a?(String)
    $_printstr_buffer += string_rb
    lines = $_printstr_buffer.split("\n", -1)
    ready_lines = lines[0..-2]
    unfinished_line = lines.last
    ready_lines.each do |line|
      string_js = BRubyBridge::JSInterface.string(line)
      key_console = BRubyBridge::JSInterface.string('console')
      key_log = BRubyBridge::JSInterface.string('log')
      BRubyBridge::JSInterface.global.get(key_console).call(key_log, string_js)
      string_rb
    end
    $_printstr_buffer = unfinished_line
    string_rb
  end

end


$_printstr_buffer = ""
module SimpleSSH
  module Helpers
    def file_mode(path)
      File.stat(path).mode % 01000
    end
  end
end

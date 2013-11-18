module SimpleSSH
  class Result
    # The pointer is freed after this call in SimpleSSH::Session#exec_command
    def self.from_pointer(pointer)
      exit_code   = SimpleSSH::Foreign.exit_code   pointer
      exit_signal = SimpleSSH::Foreign.exit_signal pointer
      out         = SimpleSSH::Foreign.out         pointer
      err         = SimpleSSH::Foreign.err         pointer
      self.new(exit_code, exit_signal, out, err)
    end

    def initialize(code, sig, out, err)
      @code, @sig, @out, @err = code, sig, out, err
    end

    def signal?
      not @sig.nil?
    end

    def stdout
      @out
    end

    def stderr
      @err
    end

    def exit
      @sig == "" ? @code : @sig
    end
  end
end

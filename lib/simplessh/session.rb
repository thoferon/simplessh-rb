module SimpleSSH
  class Session
    def self.from_pointer(pointer)
      self.new(pointer)
    end

    def initialize(pointer)
      @session_pointer = pointer
    end

    def authenticate_with_password(username, password)
      either_pointer = SimpleSSH::Foreign.authenticate_with_password(@session_pointer, username, password)
      SimpleSSH::Either.from_pointer!(either_pointer) do |session_pointer|
        SimpleSSH::Session.from_pointer(session_pointer)
      end
    end

    def authenticate_with_key(username, public_key, private_key, passphrase)
      either_pointer = SimpleSSH::Foreign.authenticate_with_key(@session_pointer, username, public_key, private_key, passphrase)
      SimpleSSH::Either.from_pointer!(either_pointer) do |session_pointer|
        SimpleSSH::Session.from_pointer(session_pointer)
      end
    end

    def exec_command(cmd)
      either_pointer = SimpleSSH::Foreign.exec_command(@session_pointer, cmd)
      either_result = SimpleSSH::Either.from_pointer(either_pointer) do |result_pointer|
        SimpleSSH::Result.from_pointer(result_pointer)
      end
      SimpleSSH::Foreign.free_either_result(either_pointer)
      either_result
    end

    def send_file(mode, source, target)
      either_pointer = SimpleSSH::Foreign.send_file(@session_pointer, mode, source, target)
      either_count = SimpleSSH::Either.from_pointer(either_pointer) do |count_pointer|
        SimpleSSH::Foreign.count(count_pointer)
      end
      SimpleSSH::Foreign.free_either_count(either_pointer)
      either_count
    end

    def close
      SimpleSSH::Foreign.close_session @session_pointer
    end

    def finalize
      close
    end
  end
end

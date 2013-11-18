module SimpleSSH
  class Either
    attr_reader :val

    def self.return(val)
      self.new val
    end

    def initialize(val)
      @val = val
    end

    def self.from_pointer(pointer, &block)
      if SimpleSSH::Foreign.is_left(pointer) == 0
        value_pointer = SimpleSSH::Foreign.value pointer
        value = block.call(value_pointer)
        Right.new value
      else
        error_code = SimpleSSH::Foreign.error(pointer)
        Left.from_code(error_code)
      end
    end

    def self.from_pointer!(pointer, &block)
      result = self.from_pointer(pointer, &block)
      pointer.free
      result
    end

    def flat_map(&block)
      raise NotImplementedError
    end

    def left?
      raise NotImplementedError
    end

    def right?
      not left?
    end

    class Left < Either
      def self.from_code(code)
        err = case code
                when 1 then :connect
                when 2 then :libssh2_initialisation
                when 3 then :handshake
                when 4 then :known_hosts_initialisation
                when 5 then :known_hosts_hostkey
                when 6 then :known_hosts_check
                when 7 then :authentication
                when 8 then :channel_open
                when 9 then :channel_execution
                when 10 then :read
                when 11 then :file_open
                when 12 then :write
                else :unknown_error
              end
        self.new err
      end

      def flat_map
        self
      end

      def left?
        true
      end
    end

    class Right < Either
      def flat_map(&block)
        block.call val
      end

      def left?
        false
      end
    end
  end
end

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
        Left.new SimpleSSH::Foreign.error(pointer)
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

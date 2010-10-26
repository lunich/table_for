module CoreEx
  module ArrayIterator
    def next
      unless self.size.zero?
        res = (@current ||= 0)
        if self.size == (@current += 1)
          @current = 0
        end
        self[res]
      end
    end
  end
end

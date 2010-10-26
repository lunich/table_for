class Array
  def next
    if 0 == self.size
      nil
    else
      res = (@current ||= 0)
      if self.size == (@current += 1)
        @current = 0
      end
      self[res]
    end
  end
end

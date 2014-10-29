class Array
  def sum
    self.inject(0){|accum, i| accum + i }
  end

  def median
    self.length.odd? ? self[self.length/2 + 1].to_f : (self[self.length/2-1] + self[self.length/2])/2.0
  end

  def mean
    self.sum/self.length.to_f
  end

  def variance
    m = self.mean
    sum = self.inject(0){|accum, i| accum +(i-m)**2 }
    sum/(self.length - 1).to_f
  end

  def standard_deviation
    return Math.sqrt(self.variance)
  end
end

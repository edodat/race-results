class BikeResult < LegResult
  field :mph, type: Float

  def calc_ave
    if event && event.distance && secs && secs > 0
      self.mph = 3600 * event.miles / secs
    end
  end
end

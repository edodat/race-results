class SwimResult < LegResult
  field :pace_100, type: Float

  def calc_ave
    if event && event.distance && event.distance > 0 && secs
      self.pace_100 = 100 * secs / event.meters
    end
  end
end

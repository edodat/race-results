class RunResult < LegResult
  field :mmile, as: :minute_mile, type: Float

  def calc_ave
    if event && event.distance && event.distance > 0 && secs
      self.mmile = (secs / 60) / event.miles
    end
  end
end

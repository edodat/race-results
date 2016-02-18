class LegResult
  include Mongoid::Document
  field :secs, type: Float
  embeds_one :event, as: :parent

  validates_presence_of :event

  embedded_in :entrant

  def calc_ave
    # implemented in sub-classes
  end

  after_initialize do |doc|
    self.calc_ave
  end

  def secs= value
    self[:secs] = value
    self.calc_ave
  end
end

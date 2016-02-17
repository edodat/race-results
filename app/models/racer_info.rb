class RacerInfo
  include Mongoid::Document
  field :fn, as: :first_name, type: String
  field :ln, as: :last_name, type: String
  field :g, as: :gender, type: String
  field :yr, as: :birth_year, type: Integer
  field :res, as: :residence, type: Address
  field :racer_id, as: :_id
  field :_id, default: ->{ racer_id }

  validates_presence_of :first_name, :last_name, :gender, :birth_year
  validates_inclusion_of :gender, in: ["M", "F"], message: "must be M or F"
  validates_numericality_of :birth_year, less_than: Date.current.year, message: "must in past"

  embedded_in :parent, polymorphic: true
end

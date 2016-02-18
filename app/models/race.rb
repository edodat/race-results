class Race
  include Mongoid::Document
  include Mongoid::Timestamps

  field :n, as: :name, type: String
  field :date, type: Date
  field :loc, as: :location, type: Address

  embeds_many :events, as: :parent, order: [:order.asc]
  has_many :entrants, foreign_key: "race._id", dependent: :delete, order: [:secs.asc, :bib.asc]

  scope :upcoming, ->{ where(:date.gte=>Date.current) }
  scope :past, ->{ where(:date.lt=>Date.current) }

  ["city", "state"].each do |property|
    define_method "#{property}" do
      self.location ? self.location.send("#{property}") : nil
    end
    define_method "#{property}=" do |value|
      location = self.location || Address.new
      location.send("#{property}=", value)
      self.location = location
    end
  end

  DEFAULT_EVENTS = {"swim"=> {order:0, name:"swim", distance:1.0, units:"miles"},
                    "t1"=>   {order:1, name:"t1"},
                    "bike"=> {order:2, name:"bike", distance:25.0, units:"miles"},
                    "t2"=>   {order:3, name:"t2"},
                    "run"=>  {order:4, name:"run", distance:10.0, units:"kilometers"}}

  DEFAULT_EVENTS.keys.each do |name|
    define_method("#{name}") do
      event = events.select {|event| name == event.name}.first
      event ||= events.build DEFAULT_EVENTS[name]
    end
    ["order", "distance", "units"].each do |property|
      if DEFAULT_EVENTS[name][property.to_sym]
        define_method "#{name}_#{property}" do
          event = self.send("#{name}").send("#{property}")
        end
        define_method "#{name}_#{property}=" do |value|
          event = self.send("#{name}").send("#{property}=", value)
        end
      end
    end
  end

  def self.default
    Race.new do |race|
      DEFAULT_EVENTS.keys.each {|name| race.send("#{name}")}
    end
  end
end

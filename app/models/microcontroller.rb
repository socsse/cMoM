class Microcontroller
  include Mongoid::Document

    field :clock_source,         type: String, default:"clock_source_2"
    field :clock_frequency,      type: Float,  default: 100.0
    field :operating_conditions, type: String, default: "COM"

    embedded_in :chip

    validates_numericality_of :clock_frequency, greater_than_or_equal_to: 0.0, less_than_or_equal_to: 200.0

    def options_for_clock_source
      [["Clock Source 1", "clock_source_1"], ["Clock Source 2", "clock_source_2"]]
    end

    def options_for_operating_conditions
      [["COM"], ["IND"], ["MIL"]]
    end

    def json_obj_for_config_file
      {
        :clock_source => self.clock_source,
        :clock_frequency => self.clock_frequency,
        :operating_conditions => self.operating_conditions
      }
    end
end

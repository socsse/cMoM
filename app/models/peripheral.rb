class Peripheral
  include Mongoid::Document

    field :name, type: String

    embedded_in :chip

    validates_presence_of   :name
    validates_uniqueness_of :name

    def type
      "Peripheral"
    end

    def json_obj_for_config_file
      {
        :name => self.name,
        :type => self.type,
      }
    end
end

class Peripheral
  include Mongoid::Document

    field :name, type: String

    embedded_in :chip

    def json_obj_for_config_file
      {
        :name => self.name,
        :type => self.type,
      }
    end
end

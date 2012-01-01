class Memory
  include Mongoid::Document

    field :nvm,  type: String,  default: "512"
    field :sram, type: String,  default: "32"
    field :emi,  type: Boolean, default: false

    embedded_in :chip

    def options_for_nvm
      [["256 Kbytes", "256"], ["512 Kbytes", "512"], ["1 Mbyte", "1024"], ["2 Mbytes", "2048"]]
    end

    def options_for_sram
      [["16 Kbytes", "16"], ["32 Kbytes", "32"], ["64 Kbytes", "64"]]
    end

    def json_obj_for_config_file
      {
        :nvm => self.nvm,
        :sram => self.sram,
        :emi => self.emi
      }
    end
end

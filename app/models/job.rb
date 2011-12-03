class Job
  include Mongoid::Document

  field :status,      type: String

  field :config_file, type: String
  field :log_file,    type: String

  embedded_in :chip
end

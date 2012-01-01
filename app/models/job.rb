class Job
  include Mongoid::Document

  STATUS = {
    :not_started  => "not_started",
    :queued       => "queued",
    :running      => "running",
    :finished     => "finished",
    :failed       => "failed",
    :test_running => "test_running" }

  field :status,      type: String, default: STATUS[:not_started]

  field :config_file, type: String
  field :output_file, type: String

  embedded_in :chip
end

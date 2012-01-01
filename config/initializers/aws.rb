require 'aws'
require 'yaml'

AWS.config(:logger => Rails.logger)

AWS_CONFIG_DATA = YAML.load(ERB.new(File.read(File.join(Rails.root, "config", "aws.yml"))).result)[Rails.env]
Rails.logger.info "#{AWS_CONFIG_DATA}"

AWS.config( AWS_CONFIG_DATA )


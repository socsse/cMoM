require 'yaml'

config = YAML.load_file(ERB.new(File.join(Rails.root, "config", "aws.yml")).result)
Rails.logger.info "#{config}"
AWS.config( config )

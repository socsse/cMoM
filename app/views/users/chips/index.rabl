collection @chips
attributes :_id => :id
attributes :name
child( :job ) { attributes :status, :config_file, :output_file } 

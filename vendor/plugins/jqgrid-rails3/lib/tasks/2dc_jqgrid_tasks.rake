namespace :jqgrid do

	if (rails_version_ge_3_1 = File.exist?(File.join(Rails.root, 'app', 'assets')))
		target_dir = File.join(Rails.root, 'vendor', 'assets')		# rails >= 3.1.0
	else
		target_dir = File.join(Rails.root, 'public')			# rails < 3.1.0
	end

	desc "Copy javascripts, stylesheets and images to public or assets (rails >=3.1)"
	task :install do
		Rake::Task[ "jqgrid:uninstall" ].execute

		# Stylesheets
		source = File.expand_path(File.join(File.dirname(__FILE__),'..', '..', 'public', 'stylesheets'))
		target = File.join(target_dir, 'stylesheets', 'jqgrid')
		FileUtils.mkdir_p target			
		FileUtils.copy_entry(source, target, :verbose => true)

		# Javascripts
		source = File.expand_path(File.join(File.dirname(__FILE__),'..', '..', 'public', 'javascripts'))
		target = File.join(target_dir, 'javascripts', 'jqgrid', 'i18n')
		FileUtils.mkdir_p target			
		FileUtils.copy_entry(File.join(source, 'i18n'), target, :verbose => true)

		target = File.join(target_dir, 'javascripts', 'jqgrid')
		# For rails >3.1.0 jquery already installed and copy jqgrid source instead of minified version.
		if rails_version_ge_3_1
			FileUtils.copy(File.join(source, 'jquery.jqGrid.src.js'), target, :verbose => true)
		else
			files = Dir.glob(File.join(source, '*.min.js'))
			files.each {|f| FileUtils.copy(f, target, :verbose => true)}
		end
	end

	desc 'Remove javascripts, stylesheets and images from public or assets (rails >=3.1)'
	task :uninstall do
		%w(javascripts stylesheets).each do |dir|
			target = File.join(target_dir, dir, 'jqgrid')
			FileUtils.rm_rf(target, :verbose => true)
		end
	end
end

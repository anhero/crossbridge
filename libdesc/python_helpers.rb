library = Library.new(name: "Python helpers")
library.installer = make_step do 
	FileUtils.mkdir_p "#{library.options.install_dir}/bin/"

	['add-opt-in.py', 
	'projector-dis.py', 
	'swfdink.py', 
	'swf-info.py'].each do |name|
		FileUtils.cp_r "#{$global_state.project_dir}/tools/utils-py/#{name}", "#{library.options.install_dir}/bin/"
	end	
end
library = Library.new(name: "public-api")
library.installer = make_step do 
	FileUtils.cp_r "#{$global_state.project_dir}/avm2_env/public-api.txt", "#{@library.options.install_dir}"
	true
end
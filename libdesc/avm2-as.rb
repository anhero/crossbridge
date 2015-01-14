library = Library.new(name: "avm2-as")

library.builder = make_step do 
	files =[]
	files << "#{$global_state.project_dir}/avm2_env/misc/SetAlchemySDKLocation.c"
	files << "#{$global_state.project_dir}/tools/as/as.cpp"

	Exec.run(%{#{@library.options.CXX} #{files.join ' '} -o "#{@library.work_dir}/#{@library.name}#{@library.options.EXEEXT}"})  or raised "#{@library.name} failed"
end

library.installer = make_step do 
	FileUtils.cp_r "#{@library.work_dir}/#{@library.name}#{@library.options.EXEEXT}", "#{@library.options.install_dir}/bin/"
end
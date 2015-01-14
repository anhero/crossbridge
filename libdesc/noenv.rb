library = Library.new(name: "noenv")

library.builder = make_step do 
	Exec.run(%{#{@library.options.CC} #{$global_state.project_dir}/tools/noenv/#{@library.name}.c -o "#{@library.work_dir}/#{@library.name}#{@library.options.EXEEXT}"})  or raised "#{@library.name} failed"
end

library.installer = make_step do 
	FileUtils.cp_r "#{@library.work_dir}/#{@library.name}#{@library.options.EXEEXT}", "#{@library.options.install_dir}/bin/"
end
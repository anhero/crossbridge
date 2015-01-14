library = Library.new(name: "avm2_env")
library.installer = make_step do 
	Exec.run(%{#{@library.options.RSYNC} --exclude '*iconv.h' #{$global_state.project_dir}/avm2_env/usr/include/ #{@library.options.install_dir}/include}) or raise 'RSYNC failed'
	Exec.run(%{#{@library.options.RSYNC} #{$global_state.project_dir}/avm2_env/usr/lib/ #{@library.options.install_dir}/lib}) or raise 'RSYNC failed'
end
library = Library.new(name: "avmplus", version: "master")
library.archive = "#{library.name}-#{library.version}.zip"
library.fetcher   = Fetcher::Copy "packages/#{library.archive}"
library.patcher = Patcher::Copy "patches/#{library.name}-#{library.version}"


library.builder = make_step do
		params = '-abcfuture -config CONFIG::VMCFG_FLOAT=false -config CONFIG::VMCFG_ALCHEMY_SDK_BUILD=true -config CONFIG::VMCFG_ALCHEMY_POSIX=true'

		FileUtils.chdir "#{@library.work_dir}/#{@library.build_subdir}/core"
		Exec.run(%{#{@library.options.PYTHON} ./builtin.py #{params}}) or raise 'builtin.py failed'

		FileUtils.chdir "#{@library.work_dir}/#{@library.build_subdir}/shell"
		Exec.run(%{#{@library.options.PYTHON} #{$global_state.project_dir}/posix/gensyscalls.py #{$global_state.project_dir}/posix/syscalls.changed}) or raise 'gensyscalls.py failed'
		Exec.run(%{#{@library.options.PYTHON} ./shell_toplevel.py #{params}}) or raise 'shell_toplevel.py failed'
	
		FileUtils.chdir $global_state.work_dir

		builtin_options =[]
		builtin_options << "-import #{@library.work_dir}/#{@library.build_subdir}/generated/builtin.abc"
		builtin_options << "-import #{@library.work_dir}/#{@library.build_subdir}/generated/shell_toplevel.abc"
		['swfmake', 'projectormake', 'abcdump'].each do |file|
			Exec.run(%{#{@library.options.ASC2_compiler} #{builtin_options.join ' '} #{@library.work_dir}/#{@library.build_subdir}/utils/#{file}.as -outdir . -out #{file}}) or raise "#{file} failed"
		end	

end


library.installer = make_step do
		FileUtils.rm_rf "#{$global_state.work_dir}/avmplus" if File.exist? "#{$global_state.work_dir}/avmplus"
		FileUtils.cp_r  "#{@library.work_dir}/#{@library.build_subdir}", "#{$global_state.work_dir}/avmplus"

		FileUtils.mkdir_p "#{@library.options.install_dir}/lib"
		FileUtils.cp_r Dir.glob("#{$global_state.work_dir}/avmplus/generated/*.abc"), "#{@library.options.install_dir}/lib"
end




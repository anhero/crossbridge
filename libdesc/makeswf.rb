library = Library.new(name: "makeswf")

library.options.CXXFLAGS << "-I#{$global_state.project_dir}/avm2_env/misc"
library.options.CXXFLAGS << "-I#{$global_state.project_dir}/binutils/include"
library.options.CXXFLAGS << '-DHAVE_ABCNM'
library.options.CXXFLAGS << '-DDEFTMPDIR=\"/tmp\"'
library.options.CXXFLAGS << "-DDEFSYSROOT=#{library.options.install_dir}"
library.options.CXXFLAGS << '-DHAVE_STDINT_H'
library.options.CXXFLAGS << '-fPIC'

library.options.CXXFLAGS << '-shared'
library.options.CXXFLAGS << '-Wl,-headerpad_max_install_names,-undefined,dynamic_lookup'



library.builder = make_step do
	FileUtils.chdir "#{@library.work_dir}"
	Exec.run(%{#{@library.options.CXX} #{@library.options.CXXFLAGS}  #{$global_state.project_dir}/gold-plugins/makeswf.cpp  -o #{@library.work_dir}/makeswf#{@library.options.EXEEXT}})  or raised "#{@library.name} failed"
end

library.installer = make_step do
	FileUtils.cp_r "#{@library.work_dir}/makeswf#{@library.options.EXEEXT}", "#{@library.options.install_dir}/lib"
end
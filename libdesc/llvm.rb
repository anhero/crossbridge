library = Library.new(name: "llvm", version: '2.9')
library.archive = "#{library.name}-#{library.version}"
library.path = library.archive
library.builder   = Builder::CMakeMake()
library.installer = Installer::MakeInstall()


library.preparer = make_step do
	FileUtils.mkdir_p "#{$global_state.work_dir}/llvm-install"
	FileUtils.mkdir_p "#{$global_state.work_dir}/extra/"

	@library.options.build_dir = @library.work_dir
	@library.options.CMAKE_DIR = "#{@library.build_subdir}"

	#TODO Do not copy avm_env, remove the include dir from the cmakelist.txt file and use a -I CXXFLAGS instead
	FileUtils.cp_r "#{$global_state.project_dir}/avm2_env", "#{@library.work_dir}"
end


library.deploy = make_step do
	FileUtils.cp_r "#{$global_state.work_dir}/llvm-install/bin/llc#{@library.options.EXEEXT}", "#{$build_options.install_dir}/bin/"
	FileUtils.cp_r "#{$global_state.work_dir}/llvm-install/bin/llvm-ar#{@library.options.EXEEXT}", "#{$build_options.install_dir}/bin/"
	FileUtils.cp_r "#{$global_state.work_dir}/llvm-install/bin/llvm-as#{@library.options.EXEEXT}", "#{$build_options.install_dir}/bin/"
	FileUtils.cp_r "#{$global_state.work_dir}/llvm-install/bin/llvm-diff#{@library.options.EXEEXT}", "#{$build_options.install_dir}/bin/"
	FileUtils.cp_r "#{$global_state.work_dir}/llvm-install/bin/llvm-dis#{@library.options.EXEEXT}", "#{$build_options.install_dir}/bin/"
	FileUtils.cp_r "#{$global_state.work_dir}/llvm-install/bin/llvm-extract#{@library.options.EXEEXT}", "#{$build_options.install_dir}/bin/"
	FileUtils.cp_r "#{$global_state.work_dir}/llvm-install/bin/llvm-ld#{@library.options.EXEEXT}", "#{$build_options.install_dir}/bin/"
	FileUtils.cp_r "#{$global_state.work_dir}/llvm-install/bin/llvm-link#{@library.options.EXEEXT}", "#{$build_options.install_dir}/bin/"
	FileUtils.cp_r "#{$global_state.work_dir}/llvm-install/bin/llvm-nm#{@library.options.EXEEXT}", "#{$build_options.install_dir}/bin/"
	FileUtils.cp_r "#{$global_state.work_dir}/llvm-install/bin/llvm-ranlib#{@library.options.EXEEXT}", "#{$build_options.install_dir}/bin/"
	FileUtils.cp_r "#{$global_state.work_dir}/llvm-install/bin/opt#{@library.options.EXEEXT}", "#{$build_options.install_dir}/bin/"
	FileUtils.cp_r Dir["#{$global_state.work_dir}/llvm-install/lib/LLVMgold.*"], "#{$build_options.install_dir}/lib/"

	FileUtils.cp_r "#{@library.work_dir}/bin/fpcmp#{@library.options.EXEEXT}", "#{$global_state.work_dir}/extra/"

end

library.options.CMAKE = "#{library.options.install_dir}/bin/cmake"
library.options.cmake_options << '-DLLVM_BUILD_CLANG=ON'
library.options.cmake_options << '-DLLVM_ENABLE_ASSERTIONS=OFF'
library.options.cmake_options << '-DLLVM_BUILD_GOLDPLUGIN=ON'
library.options.cmake_options << "-DBINUTILS_INCDIR=#{$global_state.project_dir}/binutils/include"
library.options.cmake_options << '-DLLVM_TARGETS_TO_BUILD=AVM2;AVM2Shim;X86;CBackend'
library.options.cmake_options << '-DLLVM_NATIVE_ARCH=avm2'
library.options.cmake_options << '-DLLVM_INCLUDE_TESTS=ON'
library.options.cmake_options << '-DLLVM_INCLUDE_EXAMPLES=OFF'

library.options.install_dir = "#{$global_state.work_dir}/llvm-install"


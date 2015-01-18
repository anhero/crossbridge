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
	FileUtils.cp_r "#{$global_state.project_dir}/avm2_env", "#{@library.work_dir}"
end


library.deploy = make_step do
	FileUtils.cp_r "#{$global_state.work_dir}/llvm-install/bin/llc#{$build_options.EXEEXT}", "#{$build_options.install_dir}/bin/"
	FileUtils.cp_r "#{$global_state.work_dir}/llvm-install/bin/llvm-ar#{$build_options.EXEEXT}", "#{$build_options.install_dir}/bin/"
	FileUtils.cp_r "#{$global_state.work_dir}/llvm-install/bin/llvm-as#{$build_options.EXEEXT}", "#{$build_options.install_dir}/bin/"
	FileUtils.cp_r "#{$global_state.work_dir}/llvm-install/bin/llvm-diff#{$build_options.EXEEXT}", "#{$build_options.install_dir}/bin/"
	FileUtils.cp_r "#{$global_state.work_dir}/llvm-install/bin/llvm-dis#{$build_options.EXEEXT}", "#{$build_options.install_dir}/bin/"
	FileUtils.cp_r "#{$global_state.work_dir}/llvm-install/bin/llvm-extract#{$build_options.EXEEXT}", "#{$build_options.install_dir}/bin/"
	FileUtils.cp_r "#{$global_state.work_dir}/llvm-install/bin/llvm-ld#{$build_options.EXEEXT}", "#{$build_options.install_dir}/bin/"
	FileUtils.cp_r "#{$global_state.work_dir}/llvm-install/bin/llvm-link#{$build_options.EXEEXT}", "#{$build_options.install_dir}/bin/"
	FileUtils.cp_r "#{$global_state.work_dir}/llvm-install/bin/llvm-nm#{$build_options.EXEEXT}", "#{$build_options.install_dir}/bin/"
	FileUtils.cp_r "#{$global_state.work_dir}/llvm-install/bin/llvm-ranlib#{$build_options.EXEEXT}", "#{$build_options.install_dir}/bin/"
	FileUtils.cp_r "#{$global_state.work_dir}/llvm-install/bin/opt#{$build_options.EXEEXT}", "#{$build_options.install_dir}/bin/"
	FileUtils.cp_r Dir["#{$global_state.work_dir}/llvm-install/lib/LLVMgold.*"], "#{$build_options.install_dir}/lib/"

	FileUtils.cp_r "#{@library.work_dir}/bin/fpcmp#{$build_options.EXEEXT}", "#{$global_state.work_dir}/extra/"

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


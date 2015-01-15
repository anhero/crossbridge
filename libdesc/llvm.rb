library = Library.new(name: "llvm", version: '2.9')
library.archive = "#{library.name}-#{library.version}"
library.path = library.archive
library.builder   = Builder::CMakeMake()
library.installer = Installer::MakeInstall()


library.preparer = make_step do
	FileUtils.mkdir_p "#{$global_state.work_dir}/llvm-install"
	@library.options.build_dir = @library.work_dir
	@library.options.CMAKE_DIR = "#{@library.build_subdir}"
end


library.deploy = make_step do
	raise 'debug'
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




# llvm:
# 		rm -rf $(BUILD)/llvm-debug
# mkdir -p $(BUILD)/llvm-debug

# cp $(LLVMINSTALLPREFIX)/llvm-install/bin/llc$(EXEEXT) $(SDK)/usr/bin/llc$(EXEEXT)
# ifeq ($(LLVM_ONLYLLC), false)
# cp $(LLVMINSTALLPREFIX)/llvm-install/bin/llvm-ar$(EXEEXT) $(SDK)/usr/bin/llvm-ar$(EXEEXT)
# cp $(LLVMINSTALLPREFIX)/llvm-install/bin/llvm-as$(EXEEXT) $(SDK)/usr/bin/llvm-as$(EXEEXT)
# cp $(LLVMINSTALLPREFIX)/llvm-install/bin/llvm-diff$(EXEEXT) $(SDK)/usr/bin/llvm-diff$(EXEEXT)
# cp $(LLVMINSTALLPREFIX)/llvm-install/bin/llvm-dis$(EXEEXT) $(SDK)/usr/bin/llvm-dis$(EXEEXT)
# cp $(LLVMINSTALLPREFIX)/llvm-install/bin/llvm-extract$(EXEEXT) $(SDK)/usr/bin/llvm-extract$(EXEEXT)
# cp $(LLVMINSTALLPREFIX)/llvm-install/bin/llvm-ld$(EXEEXT) $(SDK)/usr/bin/llvm-ld$(EXEEXT)
# cp $(LLVMINSTALLPREFIX)/llvm-install/bin/llvm-link$(EXEEXT) $(SDK)/usr/bin/llvm-link$(EXEEXT)
# cp $(LLVMINSTALLPREFIX)/llvm-install/bin/llvm-nm$(EXEEXT) $(SDK)/usr/bin/llvm-nm$(EXEEXT)
# cp $(LLVMINSTALLPREFIX)/llvm-install/bin/llvm-ranlib$(EXEEXT) $(SDK)/usr/bin/llvm-ranlib$(EXEEXT)
# cp $(LLVMINSTALLPREFIX)/llvm-install/bin/opt$(EXEEXT) $(SDK)/usr/bin/opt$(EXEEXT)
# cp $(LLVMINSTALLPREFIX)/llvm-install/lib/LLVMgold.* $(SDK)/usr/lib/LLVMgold$(SOEXT)
# cp -f $(BUILD)/llvm-debug/bin/fpcmp$(EXEEXT) $(BUILDROOT)/extra/fpcmp$(EXEEXT)
# endif





# cd $(BUILD)/llvm-debug && LDFLAGS="$(LLVMLDFLAGS)" CFLAGS="$(LLVMCFLAGS)" CXXFLAGS="$(LLVMCXXFLAGS)" $(SDK_CMAKE) -G "Unix Makefiles" \
# 		$(LLVMCMAKEOPTS) -DCMAKE_INSTALL_PREFIX=$(LLVMINSTALLPREFIX)/llvm-install -DCMAKE_BUILD_TYPE=$(LLVMBUILDTYPE) -DLLVM_BUILD_CLANG=$(CLANG) \
# 		-DLLVM_ENABLE_ASSERTIONS=$(LLVMASSERTIONS) -DLLVM_BUILD_GOLDPLUGIN=ON -DBINUTILS_INCDIR=$(SRCROOT)/$(DEPENDENCY_BINUTILS)/include \
# 		-DLLVM_TARGETS_TO_BUILD="$(LLVMTARGETS)" -DLLVM_NATIVE_ARCH="avm2" -DLLVM_INCLUDE_TESTS=$(LLVMTESTS) -DLLVM_INCLUDE_EXAMPLES=OFF \
# 		$(SRCROOT)/$(DEPENDENCY_LLVM) && $(MAKE) -j$(THREADS) && $(MAKE) install
library = Library.new(name: "llvm-gcc", version: '4.2', llvm_version: '2.9')
library.archive = "#{library.name}-#{library.version}-#{library.llvm_version}"
library.path = library.archive
library.builder   = Builder::ConfigureMake()
library.installer = Installer::MakeInstall()

library.preparer = make_step do
	@library.options.build_dir = "#{@library.work_dir}"
	@library.options.CONFIGURE = "#{@library.build_subdir}/configure"
end

cflags = []
cflags << "-DSHARED_LIBRARY_EXTENSION=#{library.options.SOEXT}"
cflags << "#{library.options.BUILD_VER_DEFS}"
cflags << '-Os'
cflags << "-I#{$global_state.project_dir}/avm2_env/misc"
library.options.CFLAGS.push *(cflags)


library.options.configure_options << '--enable-languages=c,c++'
library.options.configure_options << "--enable-llvm=#{$global_state.work_dir}/llvm-install/"
library.options.configure_options << '--disable-bootstrap'
library.options.configure_options << '--disable-multilib'
library.options.configure_options << '--disable-libada'
library.options.configure_options << '--disable-doc'
library.options.configure_options << '--disable-nls'
library.options.configure_options << '--enable-sjlj-exceptions'
library.options.configure_options << '--disable-shared'
library.options.configure_options << '--program-prefix='
library.options.configure_options << '--with-sysroot='
library.options.configure_options << "--with-build-sysroot=#{library.options.install_dir}"
library.options.configure_options << "--build=#{library.options.BUILD_TRIPLE}"
library.options.configure_options << "--host=#{library.options.HOST_TRIPLE}"
library.options.configure_options << "--target=#{library.options.TRIPLE}"

library.options.make_options << 'all-gcc'
library.options.make_options << "CFLAGS_FOR_TARGET=#{cflags.join} -emit-llvm"
library.options.make_options << "CXXFLAGS_FOR_TARGET=#{cflags.join} -emit-llvm"
library.options.make_install_target = 'install-gcc'


library.cleanup = make_step do
	FileUtils.rm_rf Dir["#{@library.options.install_dir}/bin/gccbug*"]
	FileUtils.rm_rf "#{@library.options.install_dir}/avm2-unknown-freebsd8"
	FileUtils.mv Dir["#{@library.options.install_dir}/lib/gcc/*"], "#{@library.options.install_dir}/lib/"
	FileUtils.rm_rf "#{@library.options.install_dir}/lib/gcc/"
	Exec.run(%{#{@library.options.RSYNC} #{@library.options.install_dir}/libexec/gcc/avm2-unknown-freebsd8/4.2.1 #{@library.options.install_dir}/bin/}) or raise "rsync failed"
end
library = Library.new(name: "binutils")
library.archive = "#{library.name}"
library.path = library.archive
library.builder   = Builder::ConfigureMake()
library.installer = Installer::MakeInstall()

library.options.CFLAGS << "-I#{$global_state.project_dir}/avm2_env/misc/ "
library.options.CXXFLAGS << "-I#{$global_state.project_dir}/avm2_env/misc/ "
library.options.configure_options << '--disable-doc'
library.options.configure_options << '--disable-nls'
library.options.configure_options << '--enable-gold'
library.options.configure_options << '--disable-ld'
library.options.configure_options << '--enable-plugins'
library.options.configure_options << "--build=#{library.options.BUILD_TRIPLE}"
library.options.configure_options << "--host=#{library.options.HOST_TRIPLE}"
library.options.configure_options << "--target=#{library.options.TRIPLE}"
library.options.configure_options << "--with-sysroot=#{library.options.install_dir}"
library.options.configure_options << '--program-prefix='
library.options.configure_options << '--disable-werror'
library.options.configure_options << "--enable-targets=#{library.options.TRIPLE}"

library.clean = make_step do
	FileUtils.rm_rf ["#{@library.options.install_dir}/bin/readelf#{@library.options.EXEEXT}",
									 "#{@library.options.install_dir}/bin/elfedit#{@library.options.EXEEXT}",
									 "#{@library.options.install_dir}/bin/ld.bfd#{@library.options.EXEEXT}",
									 "#{@library.options.install_dir}/bin/objdump#{@library.options.EXEEXT}",
									 "#{@library.options.install_dir}/bin/objcopy#{@library.options.EXEEXT}",
									 "#{@library.options.install_dir}/share/info",
									 "#{@library.options.install_dir}/share/man",
									 "#{@library.options.install_dir}/bin/ld#{@library.options.EXEEXT}",
									 "#{@library.options.install_dir}/#{@library.options.TRIPLE}"]

	FileUtils.mv "#{@library.options.install_dir}/bin/ld.gold#{@library.options.EXEEXT}", "#{@library.options.install_dir}/bin/ld#{@library.options.EXEEXT}"
end

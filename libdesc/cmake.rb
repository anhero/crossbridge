library = Library.new(name: "cmake", version: "3.0.0")
library.archive = "#{library.name}-#{library.version}.tar.gz"
library.fetcher = Fetcher::Copy "packages/#{library.archive}"
library.builder   = Builder::ConfigureMake()
library.installer = Installer::MakeInstall()

library.preparer = make_step do 
	@library.options.configure_options << '--docdir=cmake_junk'
	@library.options.configure_options << '--mandir=cmake_junk'
end

library.cleanuper  = make_step do
	FileUtils.rm_rf "#{@library.options.install_dir}/cmake_junk"
end

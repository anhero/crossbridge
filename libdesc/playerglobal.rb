playerglobal_path = Dir["#{$global_state.project_dir}/tools/playerglobal/*"].last

library = Library.new(name: "playerglobal")
library.installer = make_step do 
	FileUtils.mkdir_p "#{library.options.install_dir}/lib/"

	['airglobal.abc', 
	'airglobal.swc', 
	'playerglobal.abc', 
	'playerglobal.swc',
	'builtin.abc'].each do |name|
		FileUtils.cp_r "#{playerglobal_path}/#{name}", "#{library.options.install_dir}/lib/"
	end	

	FileUtils.cp_r "#{playerglobal_path}/builtin.abc", "#{$global_state.work_dir}/avmplus/generated"
end
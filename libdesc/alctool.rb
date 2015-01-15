library = Library.new(name: "alctool")


library.builder = make_step do
	Dir.chdir "#{@library.work_dir}"

	FileUtils.mkdir_p "#{@library.work_dir}/flascc"
	FileUtils.cp_r Dir["#{$global_state.project_dir}/tools/aet/*.java"], "#{@library.work_dir}/flascc"
	FileUtils.cp_r Dir["#{$global_state.project_dir}/tools/common/java/flascc/*.java"], "#{@library.work_dir}/flascc"
	Exec.run(%{#{@library.options.JAVAC} #{@library.options.JAVACOPTS} flascc/*.java -cp #{$global_state.project_dir}/tools/lib-air/compiler.jar}) or raise 'JAVAC failed on alctool'
	File.open("MANIFEST.MF", "w") do |f|
		f.puts 'Main-Class: flascc.AlcTool'
		f.puts 'Class-Path: compiler.jar'
	end
	Exec.run(%{jar cmf MANIFEST.MF alctool.jar flascc/*.class}) or raise 'jar failed on alctool'
end

library.installer = make_step do
		FileUtils.cp_r Dir["#{$global_state.project_dir}/tools/lib-air/*.jar"], "#{@library.options.install_dir}/lib" 
		FileUtils.cp_r Dir["#{$global_state.project_dir}/tools/lib-air/legacy/*.jar"], "#{@library.options.install_dir}/lib"
		FileUtils.cp_r "#{@library.work_dir}/alctool.jar", "#{@library.options.install_dir}/lib"
end

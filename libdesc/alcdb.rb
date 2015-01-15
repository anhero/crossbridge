library = Library.new(name: "alcdb")


library.builder = make_step do
	Dir.chdir "#{@library.work_dir}"

	FileUtils.mkdir_p "#{@library.work_dir}/flascc"
	FileUtils.cp_r Dir["#{$global_state.project_dir}/tools/alcdb/*.java"], "#{@library.work_dir}/flascc"
	FileUtils.cp_r Dir["#{$global_state.project_dir}/tools/common/java/flascc/*.java"], "#{@library.work_dir}/flascc"
	Exec.run(%{#{@library.options.JAVAC} #{@library.options.JAVACOPTS} flascc/*.java -cp #{$global_state.project_dir}/tools/lib-air/legacy/fdb.jar}) or raise 'JAVAC failed on alcdb'
	File.open("MANIFEST.MF", "w") do |f|
		f.puts 'Main-Class: flascc.AlcDB'
		f.puts 'Class-Path: fdb.jar'
	end
	Exec.run(%{jar cmf MANIFEST.MF alcdb.jar flascc/*.class}) or raise 'jar failed on alctool'
end

library.installer = make_step do
	FileUtils.cp_r "#{@library.work_dir}/alcdb.jar", "#{@library.options.install_dir}/lib"
end

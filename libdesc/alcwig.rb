library = Library.new(name: "alcwig")


library.builder = make_step do
	Dir.chdir "#{@library.work_dir}"

	FileUtils.mkdir_p "#{@library.work_dir}/flascc"

	FileUtils.cp_r "#{$global_state.project_dir}/tools/aet/AS3Wig.java", "#{@library.work_dir}/flascc"
	FileUtils.cp_r Dir["#{$global_state.project_dir}/tools/common/java/flascc/*.java"], "#{@library.work_dir}/flascc"
	Exec.run(%{#{@library.options.JAVAC} #{@library.options.JAVACOPTS} flascc/*.java -cp #{@library.options.install_dir}/lib/compiler.jar}) or raise 'JAVAC failed on alcwig'
	File.open("MANIFEST.MF", "w") do |f|
		f.puts 'Main-Class: flascc.AS3Wig'
		f.puts 'Class-Path: compiler.jar'
	end
	Exec.run(%{jar cmf MANIFEST.MF as3wig.jar flascc/*.class}) or raise 'jar failed on alcwig'
end

library.installer = make_step do
	FileUtils.cp_r "#{@library.work_dir}/as3wig.jar", "#{@library.options.install_dir}/lib"
end


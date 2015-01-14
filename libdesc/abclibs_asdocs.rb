library = Library.new(name: "abclibs asdocs")


library.builder = make_step do
	FileUtils.chdir @library.work_dir	
	as_doc = @library.options.AS3_ASDOC
	as3_sdk_home = @library.options.AS3_SDK_HOME

	playerglobal = Dir["#{as3_sdk_home}/frameworks/libs/player/**/playerglobal.swc"].last

 	as_doc_config = []
 	as_doc_config << '-load-config='
 	as_doc_config << "-external-library-path=#{playerglobal}"
 	as_doc_config << '-strict=false'
 	as_doc_config << '-define+=CONFIG::asdocs,true'
 	as_doc_config << '-define+=CONFIG::actual,false'
 	as_doc_config << '-define+=CONFIG::debug,false'
 	as_doc_config << "-doc-sources+=#{$global_state.project_dir}/posix/vfs"
 	as_doc_config << "-doc-sources+=#{$global_state.project_dir}/posix"
 	as_doc_config << '-keep-xml=true'
 	as_doc_config << "-exclude-sources+=#{$global_state.project_dir}/posix/startHack.as"
 	as_doc_config << "-exclude-sources+=#{$global_state.project_dir}/posix/IKernel.as"
 	as_doc_config << "-exclude-sources+=#{$global_state.project_dir}/posix/vfs/nochump"
 	as_doc_config << "-package-description-file=#{$global_state.project_dir}/test/aspackages.xml"
 	as_doc_config << '-main-title "CrossBridge API Reference"'
 	as_doc_config << '-window-title "CrossBridge API Reference"'
 	as_doc_config << '-output apidocs'

 	Exec.run("#{as_doc} #{as_doc_config.join ' '}") or raise "asdoc failed"
	FileUtils.mv "#{@library.work_dir}/apidocs/tempdita",  "#{@library.work_dir}"

	
end

library.installer = make_step do
	FileUtils.rm_rf "#{@library.options.install_dir}/share/asdocs"
	FileUtils.mkdir_p "#{@library.options.install_dir}/share/asdocs"
	FileUtils.mkdir_p "#{@library.options.install_dir}/docs/"

 	Exec.run(%{#{@library.options.RSYNC} --exclude "*.xslt" --exclude "*.html" --exclude ASDoc_Config.xml --exclude overviews.xml #{@library.work_dir}/tempdita/ #{@library.options.install_dir}/share/asdocs}) or raise "rsync failed"
	FileUtils.cp_r "#{@library.work_dir}/apidocs",  "#{@library.options.install_dir}/docs/"

end



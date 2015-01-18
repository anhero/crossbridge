
$build_options.ASC2_compiler = "java -jar #{$global_state.project_dir}/tools/lib-air/asc2.jar -merge -md -abcfuture -AS3 -parallel -inline"
$build_options.ASC2_builtin << "-import #{$global_state.work_dir}/avmplus/generated/builtin.abc"
$build_options.ASC2_builtin << "-import #{$global_state.work_dir}/avmplus/generated/shell_toplevel.abc"
$build_options.ASC2 << $build_options.ASC2_compiler
$build_options.ASC2 << $build_options.ASC2_builtin


$build_options.ASC2OPTS << '-config CONFIG::asdocs=false' 
$build_options.ASC2OPTS << '-config CONFIG::actual=true' 
$build_options.ASC2OPTS << '-config CONFIG::debug=true'
$build_options.ASC2EXTRAOPTS << '-strict'
$build_options.ASC2EXTRAOPTS << '-optimize' 
$build_options.ASC2EXTRAOPTS << '-removedeadcode'


$build_options.PYTHON = 'python'

$build_options.JAVA = 'java'
$build_options.JAVAC = 'javac'
$build_options.JAVACOPTS << '-source 1.6'
$build_options.JAVACOPTS << '-target 1.6'
$build_options.JAVACOPTS << '-Xlint:-options'



$build_options.RSYNC ='rsync -az --no-p --no-g --chmod=ugo=rwX -l'
if not ENV['AIR_HOME'].nil? then
$build_options.AS3_SDK_TYPE = 'AdobeAIR'
$build_options.AS3_SDK_HOME = ENV['AIR_HOME']
$build_options.AS3_ASDOC = %{java -classpath "#{$build_options.AS3_SDK_HOME}/lib/legacy/asdoc.jar" -Dflex.compiler.theme= -Dflexlib=#{$build_options.AS3_SDK_HOME}/frameworks flex2.tools.ASDoc -compiler.fonts.local-fonts-snapshot=}
elsif not ENV['FLEX_HOME'].nil? then
	$build_options.AS3_SDK_TYPE = 'ApacheFlex'
	$build_options.AS3_SDK_HOME = ENV['FLEX_HOME']
	$build_options.AS3_ASDOC = %{java -classpath "#{$build_options.AS3_SDK_HOME}/lib/asdoc.jar" -Dflexlib=#{$build_options.AS3_SDK_HOME}/frameworks flex2.tools.ASDoc}
else
	raise "Adobe AIR SDK and Apache Flex SDK are missing - setting the 'AIR_HOME' or 'FLEX_HOME' environment variable is essential to build the CrossBridge SDK"
end

$build_options.CC = 'gcc'
$build_options.CXX = 'g++'

uname = "#{`uname -s`.rstrip}"
if uname.include? 'CYGWIN'	then
	$build_options.EXEEXT = '.exe'
	$build_options.SOEXT = '.dll'
elsif uname.include? 'Darwin'	then
	$build_options.CXXFLAGS << "-stdlib=libstdc++"
	# $build_options.EXEEXT = ''
	$build_options.SOEXT = '.dylib'
else
	# $build_options.EXEEXT = ''
	$build_options.SOEXT = '.so'
end






build 'libdesc/avmplus.rb'

build 'libdesc/python_helpers.rb'
build 'libdesc/playerglobal.rb'

build'libdesc/avm2_env.rb'

build 'libdesc/cmake.rb'
build 'libdesc/abclibs.rb'



build 'libdesc/abclibs_asdocs.rb'

build'libdesc/public-api.rb'

build'libdesc/uname.rb'
build'libdesc/noenv.rb'
build'libdesc/avm2-as.rb'


build'libdesc/alctool.rb'
build 'libdesc/alcdb.rb'
build 'libdesc/alcwig.rb'


build 'libdesc/llvm.rb'

# BUILDORDER+= llvm binutils plugins gcc bmake
# BUILDORDER+= csu libc libthr libm libBlocksRuntime
# BUILDORDER+= gcclibs as3wig abcflashpp abcstdlibs_more
# BUILDORDER+= sdkcleanup tr trd swig genfs gdb pkgconfig libtool   
# ifeq (,$(findstring 1,$(LIGHTSDK)))
# BUILDORDER+= $(EXTRALIBORDER)
# endif
# BUILDORDER+= finalcleanup
# BUILDORDER+= $(TESTORDER)
# BUILDORDER+= samples


# EXTRALIBORDER= zlib libbzip libxz libeigen dmalloc libffi libgmp libiconv libxml2 libvgl libjpeg libpng libgif libtiff libwebp
# EXTRALIBORDER+= libogg libvorbis libflac libsndfile libsdl libfreetype libsdl_ttf libsdl_mixer libsdl_image gls3d freeglut libphysfs libncurses 
# EXTRALIBORDER+= libopenssl libmcrypt libmhash libnettle libbeecrypt  

# TESTORDER= test_hello_c test_hello_cpp test_pthreads_c_shell test_pthreads_cpp_swf test_posix 
# TESTORDER+= test_sjlj test_sjlj_opt test_eh test_eh_opt test_as3interop test_symbols  
# #TESTORDER+= gcctests swigtests llvmtests checkasm 



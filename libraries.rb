$build_options.FLASCC_VERSION_MAJOR = 15
$build_options.FLASCC_VERSION_MINOR = 0
$build_options.FLASCC_VERSION_PATCH = 0
$build_options.FLASCC_VERSION_BUILD = 3
$build_options.SDKNAME = "CrossBridge_#{$build_options.FLASCC_VERSION_MAJOR}.#{$build_options.FLASCC_VERSION_MINOR}.#{$build_options.FLASCC_VERSION_PATCH}.#{$build_options.FLASCC_VERSION_BUILD}"
$build_options.BUILD_VER_DEFS = "-DFLASCC_VERSION_MAJOR=#{$build_options.FLASCC_VERSION_MAJOR} -DFLASCC_VERSION_MINOR=#{$build_options.FLASCC_VERSION_MINOR} -DFLASCC_VERSION_PATCH=#{$build_options.FLASCC_VERSION_PATCH} -DFLASCC_VERSION_BUILD=#{$build_options.FLASCC_VERSION_BUILD}"

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


$build_options.TRIPLE='avm2-unknown-freebsd8'


uname = "#{`uname -s`.rstrip}"
if uname.include? 'CYGWIN'	then
	$build_options.EXEEXT = '.exe'
	$build_options.SOEXT = '.dll'
	$build_options.HOST_TRIPLE='i686-pc-cygwin'
	$build_options.BUILD_TRIPLE='i686-pc-cygwin'


elsif uname.include? 'Darwin'	then
	$build_options.CFLAGS << "-stdlib=libstdc++"
	$build_options.CXXFLAGS << "-stdlib=libstdc++"
	# $build_options.EXEEXT = ''
	$build_options.SOEXT = '.dylib'
	$build_options.HOST_TRIPLE='x86_64-apple-darwin10'
	$build_options.BUILD_TRIPLE='x86_64-apple-darwin10'

else
	# $build_options.EXEEXT = ''
	$build_options.SOEXT = '.so'
	$build_options.HOST_TRIPLE='x86_64-unknown-linux'
	$build_options.BUILD_TRIPLE='x86_64-unknown-linux-gnu'

end
$build_options.CFLAGS << '-O4'
$build_options.CXXFLAGS << '-O4'






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
build 'libdesc/binutils.rb'
build 'libdesc/binutils.rb'
build 'libdesc/makeswf.rb'
build 'libdesc/multiplug.rb'
build 'libdesc/llvm-gcc.rb'


# BUILDORDER+=   gcc bmake
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
# EXTRALIBORDER+= libogg libvorbis liblibmcryptflac libsndfile libsdl libfreetype libsdl_ttf libsdl_mixer libsdl_image gls3d freeglut libphysfs libncurses
# EXTRALIBORDER+= libopenssl  libmhash libnettle libbeecrypt

# TESTORDER= test_hello_c test_hello_cpp test_pthreads_c_shell test_pthreads_cpp_swf test_posix 
# TESTORDER+= test_sjlj test_sjlj_opt test_eh test_eh_opt test_as3interop test_symbols  
# #TESTORDER+= gcctests swigtests llvmtests checkasm 



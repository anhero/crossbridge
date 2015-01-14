library = Library.new(name: "abclibs")


library.builder = make_step do
		Dir.chdir "#{@library.work_dir}"

		playerglobal = "-import #{@library.options.install_dir}/lib/playerglobal.abc"
		asc2 = "#{@library.options.ASC2} #{@library.options.ASC2OPTS}"
		asc2_extra = "#{@library.options.ASC2} #{@library.options.ASC2OPTS} #{@library.options.ASC2EXTRAOPTS}"
		project_dir = $global_state.project_dir
		# DefaultPreloader.swf
		Exec.run(%{#{asc2} #{playerglobal} #{project_dir}/posix/DefaultPreloader.as -swf com.adobe.flascc.preloader.DefaultPreloader,800,600,60 -outdir . -out DefaultPreloader}) or raise "DefaultPreloader.as failed"
		
		Exec.run(%{#{asc2_extra} #{project_dir}/posix/ELF.as  -outdir . -out ELF}) or raise "ELF.as failed"
		Exec.run(%{#{asc2_extra} #{project_dir}/posix/Exit.as  -outdir . -out Exit}) or raise "Exit.as failed"
		Exec.run(%{#{asc2_extra} #{project_dir}/posix/LongJmp.as  -outdir . -out LongJmp}) or raise "LongJmp.as failed"
		Exec.run(%{#{asc2} -import Exit.abc #{project_dir}/posix/C_Run.as -outdir . -out C_Run}) or raise "C_Run.as failed"
		Exec.run(%{#{asc2_extra} #{project_dir}/posix/vfs/ISpecialFile.as  -outdir . -out ISpecialFile}) or raise "ISpecialFile.as failed"
		Exec.run(%{#{asc2_extra} #{project_dir}/posix/vfs/IBackingStore.as  -outdir . -out IBackingStore}) or raise "IBackingStore.as failed"

		Exec.run(%{#{asc2_extra} #{playerglobal} -import IBackingStore.abc #{project_dir}/posix/vfs/InMemoryBackingStore.as  -outdir . -out InMemoryBackingStore}) or raise "InMemoryBackingStore.as failed"
		Exec.run(%{#{asc2_extra} #{playerglobal} -import IBackingStore.abc -import ISpecialFile.abc #{project_dir}/posix/vfs/IVFS.as  -outdir . -out IVFS}) or raise "IVFS.as failed"

		Exec.run(%{#{asc2_extra} #{playerglobal} -import IBackingStore.abc -import ISpecialFile.abc -import IVFS.abc -import InMemoryBackingStore.abc #{project_dir}/posix/vfs/DefaultVFS.as  -outdir . -out DefaultVFS}) or raise "DefaultVFS.as failed"
		Exec.run(%{#{asc2_extra} #{playerglobal} -import IBackingStore.abc -import ISpecialFile.abc -import IVFS.abc -import InMemoryBackingStore.abc #{project_dir}/posix/vfs/DefaultVFS.as  -outdir . -out DefaultVFS}) or raise "URLLoaderVFS.as failed"

		Exec.run(%{#{asc2_extra} #{playerglobal} #{Dir.glob("#{project_dir}/posix/vfs/nochump/**/*.as").join ' '} -outdir . -out AlcVFSZip}) or raise "AlcVFSZip failed"
		Exec.run(%{#{asc2} -import Exit.abc -import C_Run.abc -import IBackingStore.abc -import ISpecialFile.abc -import IVFS.abc -import LongJmp.abc #{project_dir}/posix/CModule.as -outdir . -out CModule}) or raise "CModule.as failed"
		

		other_import = []
		other_import << '-import CModule.abc'
		other_import << '-import IBackingStore.abc'
		other_import << '-import IVFS.abc'
		other_import << '-import ISpecialFile.abc'
		other_import = other_import.join ' '
		Exec.run(%{#{asc2_extra} #{other_import} -import C_Run.abc -import Exit.abc -import ELF.abc #{project_dir}/posix/AlcDbgHelper.as -d -outdir . -out AlcDbgHelper}) or raise "AlcDbgHelper.as failed"
		Exec.run(%{#{asc2_extra} #{other_import} #{playerglobal} #{project_dir}/posix/BinaryData.as -outdir . -out BinaryData}) or raise "BinaryData.as failed"
		Exec.run(%{#{asc2_extra} #{other_import} -import C_Run.abc #{playerglobal} #{project_dir}/posix/Console.as -outdir . -out Console}) or raise "Console.as failed"
		Exec.run(%{#{asc2_extra} #{other_import} -import C_Run.abc -import Exit.abc -import ELF.abc #{project_dir}/posix/startHack.as -outdir . -out startHack}) or raise "startHack.as failed"
		Exec.run(%{#{asc2_extra} #{other_import} -import C_Run.abc #{project_dir}/posix/ShellCreateWorker.as -outdir . -out ShellCreateWorker}) or raise "ShellCreateWorker.as failed"
		Exec.run(%{#{asc2_extra} #{other_import}  -import C_Run.abc -import Exit.abc #{playerglobal} #{project_dir}/posix/PlayerCreateWorker.as -outdir . -out PlayerCreateWorker}) or raise "PlayerCreateWorker.as failed"
		Exec.run(%{#{asc2_extra} #{other_import}  -import C_Run.abc -import Exit.abc -import DefaultVFS.abc #{playerglobal} #{project_dir}/posix/PlayerKernel.as -outdir . -out PlayerKernel}) or raise "PlayerKernel.as failed"
end

library.installer = make_step do
		FileUtils.cp_r Dir.glob("#{@library.work_dir}/*.abc"), "#{@library.options.install_dir}/lib"
		FileUtils.cp_r Dir.glob("#{@library.work_dir}/*.swf"), "#{@library.options.install_dir}/lib"
end



# Microsoft Developer Studio Project File - Name="elua_simulator" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Console Application" 0x0103

CFG=elua_simulator - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "elua_simulator.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "elua_simulator.mak" CFG="elua_simulator - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "elua_simulator - Win32 Release" (based on "Win32 (x86) Console Application")
!MESSAGE "elua_simulator - Win32 Debug" (based on "Win32 (x86) Console Application")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
RSC=rc.exe

!IF  "$(CFG)" == "elua_simulator - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "Release"
# PROP Intermediate_Dir "Release"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /YX /FD /c
# ADD CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /YX /FD /c
# ADD BASE RSC /l 0x804 /d "NDEBUG"
# ADD RSC /l 0x804 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /machine:I386
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /machine:I386

!ELSEIF  "$(CFG)" == "elua_simulator - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "Debug"
# PROP Intermediate_Dir "Debug"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" /YX /FD /GZ /c
# ADD CPP /nologo /MTd /W3 /Gm /GX /ZI /Od /I "..\..\..\..\lua\include" /I "..\..\..\..\lib\lzma\include" /I "..\..\..\..\lib\crypto\include" /I "..\..\..\..\lib\zlib\include" /I "..\..\..\..\lib\zlib\zlib_pal\include" /I "..\..\..\..\lib\lpng\include" /I "..\..\..\..\lib\lpng\lpng_pal\include" /I "..\..\..\..\lib\iconv\include" /I "..\..\..\..\lib\iconv\src" /I "..\..\..\..\lua\src\\" /I "..\..\..\..\modules\include" /I "..\..\..\include" /I "..\..\include" /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" /D "AM_LUA_SUPPORT" /D "LUA_USE_COOLSAND_SXR" /D "LUA_IO_LIB" /D "LUA_DEBUG_LIB" /D "LUA_FILE_LOAD_SUPPORT" /D "LUA_TTY_SUPPORT" /D LUA_SCRIPT_SIZE=384*1024 /D "USE_DL_PREFIX" /D "USE_DLMALLOC_AS_LUA_ALLOCF" /D "USE_DLMALLOC" /D "AM_LZMA_SUPPORT" /D "AM_LPNG_SUPPORT" /D "LUA_DISP_SUPPORT_HZ" /D "LUA_ICONV_LIB" /D "LUA_OS_LIB" /D LUA_OPTIMIZE_MEMORY=0 /D fopen=elua_fopen /D getenv=lualibc_getenv /D "LUA_SAVE_LAST_ERROR" /D DEFAULT_GRANULARITY=512*1024 /D __FUNCTION__=\"func\" /D "LUA_ZLIB_LIB" /D printf=elua_printf /D fprintf=elua_fprintf /D vfprintf=elua_vfprintf /D fwrite=elua_fwrite /D fputs=elua_fputs /D freopen=elua_freopen /D "LUA_DISP_LIB" /YX /FD /GZ /c
# ADD BASE RSC /l 0x804 /d "_DEBUG"
# ADD RSC /l 0x804 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /debug /machine:I386 /pdbtype:sept
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib ws2_32.lib /nologo /subsystem:console /debug /machine:I386 /out:"release/core.exe" /pdbtype:sept
# SUBTRACT LINK32 /incremental:no

!ENDIF 

# Begin Target

# Name "elua_simulator - Win32 Release"
# Name "elua_simulator - Win32 Debug"
# Begin Group "lua"

# PROP Default_Filter ""
# Begin Group "include"

# PROP Default_Filter ""
# Begin Source File

SOURCE=..\..\..\..\lua\include\lauxlib.h
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lua\include\lua.h
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lua\include\luaconf.h
# End Source File
# End Group
# Begin Group "src"

# PROP Default_Filter ""
# Begin Source File

SOURCE=..\..\..\..\lua\src\lapi.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lua\src\lapi.h
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lua\src\lauxlib.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lua\src\lbaselib.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lua\src\lcode.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lua\src\lcode.h
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lua\src\ldblib.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lua\src\ldebug.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lua\src\ldebug.h
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lua\src\ldo.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lua\src\ldo.h
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lua\src\ldump.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lua\src\lfunc.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lua\src\lfunc.h
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lua\src\lgc.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lua\src\lgc.h
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lua\src\linit.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lua\src\liolib.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lua\src\llex.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lua\src\llex.h
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lua\src\llimits.h
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lua\src\lmathlib.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lua\src\lmem.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lua\src\lmem.h
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lua\src\loadlib.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lua\src\lobject.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lua\src\lobject.h
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lua\src\lopcodes.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lua\src\lopcodes.h
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lua\src\loslib.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lua\src\lparser.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lua\src\lparser.h
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lua\src\lrodefs.h
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lua\src\lrotable.h
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lua\src\lstate.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lua\src\lstate.h
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lua\src\lstring.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lua\src\lstring.h
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lua\src\lstrlib.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lua\src\ltable.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lua\src\ltable.h
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lua\src\ltablib.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lua\src\ltm.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lua\src\ltm.h
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lua\src\lua.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lua\src\lualib.h
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lua\src\lundump.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lua\src\lundump.h
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lua\src\lvm.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lua\src\lvm.h
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lua\src\lzio.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lua\src\lzio.h
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lua\src\print.c
# End Source File
# End Group
# End Group
# Begin Group "modules"

# PROP Default_Filter ""
# Begin Group "include No. 1"

# PROP Default_Filter ""
# Begin Source File

SOURCE=..\..\..\..\modules\include\auxmods.h
# End Source File
# End Group
# Begin Group "src No. 1"

# PROP Default_Filter ""
# Begin Source File

SOURCE=..\..\..\..\modules\src\adc.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\modules\src\audio.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\modules\src\bit.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\modules\src\bitarray.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\modules\src\cpu.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\modules\src\disp.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\modules\src\gps.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\modules\src\i2c.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\modules\src\lpack.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\modules\src\luaiconv.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\modules\src\lzlib.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\modules\src\pio.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\modules\src\pmd.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\modules\src\rtos.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\modules\src\uart.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\modules\src\watchdog.c
# End Source File
# End Group
# End Group
# Begin Group "win32"

# PROP Default_Filter ""
# Begin Group "include No. 2"

# PROP Default_Filter ""
# Begin Source File

SOURCE=..\..\include\assert.h
# End Source File
# Begin Source File

SOURCE=..\..\include\cycle_queue.h
# End Source File
# Begin Source File

SOURCE=..\..\include\devman.h
# End Source File
# Begin Source File

SOURCE=..\..\include\dlconfig.h
# End Source File
# Begin Source File

SOURCE=..\..\include\genstd.h
# End Source File
# Begin Source File

SOURCE=..\..\include\pal_mmap.h
# End Source File
# Begin Source File

SOURCE=..\..\include\platform_conf.h
# End Source File
# Begin Source File

SOURCE=..\..\include\platform_fs.h
# End Source File
# Begin Source File

SOURCE=..\..\include\type.h
# End Source File
# Begin Source File

SOURCE=..\..\src\util.h
# End Source File
# End Group
# Begin Group "src No. 2"

# PROP Default_Filter ""
# Begin Source File

SOURCE=..\..\src\cycle_queue.c
# End Source File
# Begin Source File

SOURCE=..\..\src\daemon.c
# End Source File
# Begin Source File

SOURCE=..\..\src\elua_libc.c

!IF  "$(CFG)" == "elua_simulator - Win32 Release"

!ELSEIF  "$(CFG)" == "elua_simulator - Win32 Debug"

# SUBTRACT CPP /D fopen=elua_fopen

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\..\src\event.c
# End Source File
# Begin Source File

SOURCE=..\..\src\event.h
# End Source File
# Begin Source File

SOURCE=..\..\src\list.c
# End Source File
# Begin Source File

SOURCE=..\..\src\list.h
# End Source File
# Begin Source File

SOURCE=..\..\src\main.c
# End Source File
# Begin Source File

SOURCE=..\..\src\platform.c
# End Source File
# Begin Source File

SOURCE=..\..\src\platform_audio.c
# End Source File
# Begin Source File

SOURCE=..\..\src\platform_gps.c
# End Source File
# Begin Source File

SOURCE=..\..\src\platform_lcd.c
# End Source File
# Begin Source File

SOURCE=..\..\src\platform_pmd.c
# End Source File
# Begin Source File

SOURCE=..\..\src\platform_rtos.c
# End Source File
# Begin Source File

SOURCE=..\..\src\platform_uart.c
# End Source File
# Begin Source File

SOURCE=..\..\src\platform_watchdog.c
# End Source File
# Begin Source File

SOURCE=..\..\src\sim_gpio.c
# End Source File
# Begin Source File

SOURCE=..\..\src\sim_key.c
# End Source File
# Begin Source File

SOURCE=..\..\src\thread_daemon.c
# End Source File
# Begin Source File

SOURCE=..\..\src\win_msg.h
# End Source File
# Begin Source File

SOURCE=..\..\src\win_trace.c
# End Source File
# Begin Source File

SOURCE=..\..\src\win_trace.h
# End Source File
# End Group
# End Group
# Begin Group "platform"

# PROP Default_Filter ""
# Begin Group "include No. 3"

# PROP Default_Filter ""
# Begin Source File

SOURCE=..\..\..\include\buf.h
# End Source File
# Begin Source File

SOURCE=..\..\..\include\common.h
# End Source File
# Begin Source File

SOURCE=..\..\..\include\dlmalloc.h
# End Source File
# Begin Source File

SOURCE=..\..\..\include\elua_int.h
# End Source File
# Begin Source File

SOURCE=..\..\..\include\platform.h
# End Source File
# Begin Source File

SOURCE=..\..\..\include\platform_audio.h
# End Source File
# Begin Source File

SOURCE=..\..\..\include\platform_disp.h
# End Source File
# Begin Source File

SOURCE=..\..\..\include\platform_i2c.h
# End Source File
# Begin Source File

SOURCE=..\..\..\include\platform_lcd.h
# End Source File
# Begin Source File

SOURCE=..\..\..\include\platform_pmd.h
# End Source File
# Begin Source File

SOURCE=..\..\..\include\platform_rtos.h
# End Source File
# Begin Source File

SOURCE=..\..\..\include\platform_stubs.h
# End Source File
# Begin Source File

SOURCE=..\..\..\include\preload.h
# End Source File
# Begin Source File

SOURCE=..\..\..\include\sermux.h
# End Source File
# Begin Source File

SOURCE=..\..\..\include\utils.h
# End Source File
# End Group
# Begin Group "src No. 3"

# PROP Default_Filter ""
# Begin Source File

SOURCE=..\..\..\src\buf.c
# End Source File
# Begin Source File

SOURCE=..\..\..\src\common.c
# End Source File
# Begin Source File

SOURCE=..\..\..\src\common_disp.c

!IF  "$(CFG)" == "elua_simulator - Win32 Release"

!ELSEIF  "$(CFG)" == "elua_simulator - Win32 Debug"

# ADD CPP /Zp8 /YX

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\..\..\src\common_tmr.c
# End Source File
# Begin Source File

SOURCE=..\..\..\src\common_uart.c
# End Source File
# Begin Source File

SOURCE=..\..\..\src\crc.c
# End Source File
# Begin Source File

SOURCE=..\..\..\src\dlmalloc.c
# End Source File
# Begin Source File

SOURCE=..\..\..\src\elua_int.c
# End Source File
# Begin Source File

SOURCE=..\..\..\src\preload.c
# End Source File
# End Group
# End Group
# Begin Group "shell"

# PROP Default_Filter ""
# Begin Source File

SOURCE=..\..\..\..\shell\src\shell.c
# End Source File
# End Group
# Begin Group "lib"

# PROP Default_Filter ""
# Begin Group "crypto"

# PROP Default_Filter ""
# Begin Source File

SOURCE=..\..\..\..\lib\crypto\src\aes.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\crypto\src\aliyun_iot_common_base64.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\crypto\src\aliyun_iot_common_hmac.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\crypto\src\aliyun_iot_common_md5.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\crypto\src\aliyun_iot_common_sha1.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\crypto\src\crypto.c
# End Source File
# End Group
# Begin Group "json"

# PROP Default_Filter ""
# Begin Source File

SOURCE=..\..\..\..\lib\json\src\fpconv.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\json\src\fpconv.h
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\json\src\lua_cjson.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\json\src\strbuf.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\json\src\strbuf.h
# End Source File
# End Group
# Begin Group "lzma"

# PROP Default_Filter ""
# Begin Source File

SOURCE=..\..\..\..\lib\lzma\src\7zFile.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\lzma\src\7zFile.h
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\lzma\src\7zStream.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\lzma\src\LzFind.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\lzma\src\LzFind.h
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\lzma\src\LzHash.h
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\lzma\src\LzmaDec.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\lzma\src\LzmaDec.h
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\lzma\src\LzmaLib.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\lzma\include\LzmaLib.h
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\lzma\src\Types.h
# End Source File
# End Group
# Begin Group "iconv"

# PROP Default_Filter ""
# Begin Source File

SOURCE=..\..\..\..\lib\iconv\src\gb2312_to_ucs2.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\iconv\src\gb2312_to_ucs2_table.h
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\iconv\src\iconv.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\iconv\include\iconv.h
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\iconv\src\prv_iconv.h
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\iconv\src\ucs2_to_gb2312.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\iconv\src\ucs2_to_gb2312_offset.h
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\iconv\src\ucs2_to_gb2312_table.h
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\iconv\src\utf8_to_ucs2.c
# End Source File
# End Group
# Begin Group "zlib"

# PROP Default_Filter ""
# Begin Source File

SOURCE=..\..\..\..\lib\zlib\src\adler32.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\zlib\src\compress.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\zlib\src\crc32.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\zlib\src\crc32.h
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\zlib\src\deflate.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\zlib\src\deflate.h
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\zlib\zlib_pal\src\example.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\zlib\src\gzclose.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\zlib\src\gzguts.h
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\zlib\src\gzlib.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\zlib\src\gzread.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\zlib\src\gzwrite.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\zlib\src\infback.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\zlib\src\inffast.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\zlib\src\inffast.h
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\zlib\src\inffixed.h
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\zlib\src\inflate.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\zlib\src\inflate.h
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\zlib\src\inftrees.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\zlib\src\inftrees.h
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\zlib\src\trees.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\zlib\src\trees.h
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\zlib\src\uncompr.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\zlib\include\zconf.h
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\zlib\include\zlib.h
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\zlib\src\zutil.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\zlib\src\zutil.h
# End Source File
# End Group
# Begin Group "lpng"

# PROP Default_Filter ""
# Begin Source File

SOURCE=..\..\..\..\lib\lpng\src\png.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\lpng\src\pngerror.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\lpng\src\pngget.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\lpng\src\pngmem.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\lpng\src\pngpread.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\lpng\src\pngread.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\lpng\src\pngrio.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\lpng\src\pngrtran.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\lpng\src\pngrutil.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\lpng\src\pngset.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\lpng\src\pngtrans.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\lpng\src\pngwio.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\lpng\src\pngwtran.c
# End Source File
# Begin Source File

SOURCE=..\..\..\..\lib\lpng\src\pngwutil.c
# End Source File
# End Group
# End Group
# End Target
# End Project

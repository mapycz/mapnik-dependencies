@echo off
SETLOCAL
SET EL=0
echo ------ pixman -----

:: guard to make sure settings have been sourced
IF "%ROOTDIR%"=="" ( echo "ROOTDIR variable not set" && GOTO DONE )

cd %PKGDIR%
CALL %ROOTDIR%\scripts\download pixman-%PIXMAN_VERSION%.tar.gz
IF ERRORLEVEL 1 GOTO ERROR

if EXIST pixman (
  echo found extracted sources
)


SETLOCAL ENABLEDELAYEDEXPANSION
if NOT EXIST pixman (
  echo extracting
  CALL bsdtar xfz pixman-%PIXMAN_VERSION%.tar.gz
  IF !ERRORLEVEL! NEQ 0 GOTO ERROR
  rename pixman-%PIXMAN_VERSION% pixman
  IF !ERRORLEVEL! NEQ 0 GOTO ERROR
  cd %PKGDIR%\pixman
  IF !ERRORLEVEL! NEQ 0 GOTO ERROR
  ECHO patching ...
  patch -N -p1 < %PATCHES%/pixman.diff || %SKIP_FAILED_PATCH%
  IF !ERRORLEVEL! NEQ 0 GOTO ERROR
)
ENDLOCAL


cd %PKGDIR%\pixman\pixman
IF %ERRORLEVEL% NEQ 0 GOTO ERROR

::ECHO cleaning ....
::CALL make -f Makefile.win32 "CFG=release" clean
::IF ERRORLEVEL 1 GOTO ERROR

SET CFG_TYPE=release
IF %BUILD_TYPE% EQU Debug (SET CFG_TYPE=debug)


echo ATTENTION using "MMX=off" to compile cairo with 64bit
echo.
ECHO building ...

::>%ROOTDIR%\build_pixman-%PIXMAN_VERSION%.log 2>&1

mkdir release

cl -c -nologo -I. -I.. -I../pixman -DPACKAGE=pixman-1 -DPACKAGE_VERSION="" -DPACKAGE_BUGREPORT="" -MD -O2  -DUSE_SSE2 -DUSE_SSSE3 -Fo"release/pixman.obj" pixman.c 
cl -c -nologo -I. -I.. -I../pixman -DPACKAGE=pixman-1 -DPACKAGE_VERSION="" -DPACKAGE_BUGREPORT="" -MD -O2  -DUSE_SSE2 -DUSE_SSSE3 -Fo"release/pixman-access.obj" pixman-access.c 
cl -c -nologo -I. -I.. -I../pixman -DPACKAGE=pixman-1 -DPACKAGE_VERSION="" -DPACKAGE_BUGREPORT="" -MD -O2  -DUSE_SSE2 -DUSE_SSSE3 -Fo"release/pixman-access-accessors.obj" pixman-access-accessors.c 
cl -c -nologo -I. -I.. -I../pixman -DPACKAGE=pixman-1 -DPACKAGE_VERSION="" -DPACKAGE_BUGREPORT="" -MD -O2  -DUSE_SSE2 -DUSE_SSSE3 -Fo"release/pixman-bits-image.obj" pixman-bits-image.c 
cl -c -nologo -I. -I.. -I../pixman -DPACKAGE=pixman-1 -DPACKAGE_VERSION="" -DPACKAGE_BUGREPORT="" -MD -O2  -DUSE_SSE2 -DUSE_SSSE3 -Fo"release/pixman-combine32.obj" pixman-combine32.c 
cl -c -nologo -I. -I.. -I../pixman -DPACKAGE=pixman-1 -DPACKAGE_VERSION="" -DPACKAGE_BUGREPORT="" -MD -O2  -DUSE_SSE2 -DUSE_SSSE3 -Fo"release/pixman-combine-float.obj" pixman-combine-float.c 
cl -c -nologo -I. -I.. -I../pixman -DPACKAGE=pixman-1 -DPACKAGE_VERSION="" -DPACKAGE_BUGREPORT="" -MD -O2  -DUSE_SSE2 -DUSE_SSSE3 -Fo"release/pixman-conical-gradient.obj" pixman-conical-gradient.c 
cl -c -nologo -I. -I.. -I../pixman -DPACKAGE=pixman-1 -DPACKAGE_VERSION="" -DPACKAGE_BUGREPORT="" -MD -O2  -DUSE_SSE2 -DUSE_SSSE3 -Fo"release/pixman-filter.obj" pixman-filter.c 
cl -c -nologo -I. -I.. -I../pixman -DPACKAGE=pixman-1 -DPACKAGE_VERSION="" -DPACKAGE_BUGREPORT="" -MD -O2  -DUSE_SSE2 -DUSE_SSSE3 -Fo"release/pixman-x86.obj" pixman-x86.c 
cl -c -nologo -I. -I.. -I../pixman -DPACKAGE=pixman-1 -DPACKAGE_VERSION="" -DPACKAGE_BUGREPORT="" -MD -O2  -DUSE_SSE2 -DUSE_SSSE3 -Fo"release/pixman-mips.obj" pixman-mips.c 
cl -c -nologo -I. -I.. -I../pixman -DPACKAGE=pixman-1 -DPACKAGE_VERSION="" -DPACKAGE_BUGREPORT="" -MD -O2  -DUSE_SSE2 -DUSE_SSSE3 -Fo"release/pixman-arm.obj" pixman-arm.c 
cl -c -nologo -I. -I.. -I../pixman -DPACKAGE=pixman-1 -DPACKAGE_VERSION="" -DPACKAGE_BUGREPORT="" -MD -O2  -DUSE_SSE2 -DUSE_SSSE3 -Fo"release/pixman-ppc.obj" pixman-ppc.c 
cl -c -nologo -I. -I.. -I../pixman -DPACKAGE=pixman-1 -DPACKAGE_VERSION="" -DPACKAGE_BUGREPORT="" -MD -O2  -DUSE_SSE2 -DUSE_SSSE3 -Fo"release/pixman-edge.obj" pixman-edge.c 
cl -c -nologo -I. -I.. -I../pixman -DPACKAGE=pixman-1 -DPACKAGE_VERSION="" -DPACKAGE_BUGREPORT="" -MD -O2  -DUSE_SSE2 -DUSE_SSSE3 -Fo"release/pixman-edge-accessors.obj" pixman-edge-accessors.c 
cl -c -nologo -I. -I.. -I../pixman -DPACKAGE=pixman-1 -DPACKAGE_VERSION="" -DPACKAGE_BUGREPORT="" -MD -O2  -DUSE_SSE2 -DUSE_SSSE3 -Fo"release/pixman-fast-path.obj" pixman-fast-path.c 
cl -c -nologo -I. -I.. -I../pixman -DPACKAGE=pixman-1 -DPACKAGE_VERSION="" -DPACKAGE_BUGREPORT="" -MD -O2  -DUSE_SSE2 -DUSE_SSSE3 -Fo"release/pixman-glyph.obj" pixman-glyph.c 
cl -c -nologo -I. -I.. -I../pixman -DPACKAGE=pixman-1 -DPACKAGE_VERSION="" -DPACKAGE_BUGREPORT="" -MD -O2  -DUSE_SSE2 -DUSE_SSSE3 -Fo"release/pixman-general.obj" pixman-general.c 
cl -c -nologo -I. -I.. -I../pixman -DPACKAGE=pixman-1 -DPACKAGE_VERSION="" -DPACKAGE_BUGREPORT="" -MD -O2  -DUSE_SSE2 -DUSE_SSSE3 -Fo"release/pixman-gradient-walker.obj" pixman-gradient-walker.c 
cl -c -nologo -I. -I.. -I../pixman -DPACKAGE=pixman-1 -DPACKAGE_VERSION="" -DPACKAGE_BUGREPORT="" -MD -O2  -DUSE_SSE2 -DUSE_SSSE3 -Fo"release/pixman-image.obj" pixman-image.c 
cl -c -nologo -I. -I.. -I../pixman -DPACKAGE=pixman-1 -DPACKAGE_VERSION="" -DPACKAGE_BUGREPORT="" -MD -O2  -DUSE_SSE2 -DUSE_SSSE3 -Fo"release/pixman-implementation.obj" pixman-implementation.c 
cl -c -nologo -I. -I.. -I../pixman -DPACKAGE=pixman-1 -DPACKAGE_VERSION="" -DPACKAGE_BUGREPORT="" -MD -O2  -DUSE_SSE2 -DUSE_SSSE3 -Fo"release/pixman-linear-gradient.obj" pixman-linear-gradient.c 
cl -c -nologo -I. -I.. -I../pixman -DPACKAGE=pixman-1 -DPACKAGE_VERSION="" -DPACKAGE_BUGREPORT="" -MD -O2  -DUSE_SSE2 -DUSE_SSSE3 -Fo"release/pixman-matrix.obj" pixman-matrix.c 
cl -c -nologo -I. -I.. -I../pixman -DPACKAGE=pixman-1 -DPACKAGE_VERSION="" -DPACKAGE_BUGREPORT="" -MD -O2  -DUSE_SSE2 -DUSE_SSSE3 -Fo"release/pixman-noop.obj" pixman-noop.c 
cl -c -nologo -I. -I.. -I../pixman -DPACKAGE=pixman-1 -DPACKAGE_VERSION="" -DPACKAGE_BUGREPORT="" -MD -O2  -DUSE_SSE2 -DUSE_SSSE3 -Fo"release/pixman-radial-gradient.obj" pixman-radial-gradient.c 
cl -c -nologo -I. -I.. -I../pixman -DPACKAGE=pixman-1 -DPACKAGE_VERSION="" -DPACKAGE_BUGREPORT="" -MD -O2  -DUSE_SSE2 -DUSE_SSSE3 -Fo"release/pixman-region16.obj" pixman-region16.c 
cl -c -nologo -I. -I.. -I../pixman -DPACKAGE=pixman-1 -DPACKAGE_VERSION="" -DPACKAGE_BUGREPORT="" -MD -O2  -DUSE_SSE2 -DUSE_SSSE3 -Fo"release/pixman-region32.obj" pixman-region32.c 
cl -c -nologo -I. -I.. -I../pixman -DPACKAGE=pixman-1 -DPACKAGE_VERSION="" -DPACKAGE_BUGREPORT="" -MD -O2  -DUSE_SSE2 -DUSE_SSSE3 -Fo"release/pixman-solid-fill.obj" pixman-solid-fill.c 
cl -c -nologo -I. -I.. -I../pixman -DPACKAGE=pixman-1 -DPACKAGE_VERSION="" -DPACKAGE_BUGREPORT="" -MD -O2  -DUSE_SSE2 -DUSE_SSSE3 -Fo"release/pixman-timer.obj" pixman-timer.c 
cl -c -nologo -I. -I.. -I../pixman -DPACKAGE=pixman-1 -DPACKAGE_VERSION="" -DPACKAGE_BUGREPORT="" -MD -O2  -DUSE_SSE2 -DUSE_SSSE3 -Fo"release/pixman-trap.obj" pixman-trap.c 
cl -c -nologo -I. -I.. -I../pixman -DPACKAGE=pixman-1 -DPACKAGE_VERSION="" -DPACKAGE_BUGREPORT="" -MD -O2  -DUSE_SSE2 -DUSE_SSSE3 -Fo"release/pixman-utils.obj" pixman-utils.c 
cl -c -nologo -I. -I.. -I../pixman -DPACKAGE=pixman-1 -DPACKAGE_VERSION="" -DPACKAGE_BUGREPORT="" -MD -O2  -DUSE_SSE2 -DUSE_SSSE3 -Fo"release/pixman-sse2.obj" pixman-sse2.c 
cl -c -nologo -I. -I.. -I../pixman -DPACKAGE=pixman-1 -DPACKAGE_VERSION="" -DPACKAGE_BUGREPORT="" -MD -O2  -DUSE_SSE2 -DUSE_SSSE3 -Fo"release/pixman-ssse3.obj" pixman-ssse3.c 

lib -nologo -out:pixman-1.lib %CFG_TYPE%\p*.obj
copy pixman-1.lib %CFG_TYPE%\pixman-1.lib

IF ERRORLEVEL 1 GOTO ERROR

GOTO DONE

:ERROR
SET EL=%ERRORLEVEL%
ECHO ========= ERROR PIXMAN

:DONE
cd %ROOTDIR%
EXIT /b %EL%

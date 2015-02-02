@echo off
SETLOCAL
SET EL=0
echo ------ libxslt -----

:: guard to make sure settings have been sourced
IF "%ROOTDIR%"=="" ( echo "ROOTDIR variable not set" && GOTO DONE )


cd %PKGDIR%

if EXIST libxslt (
  echo found sources
)

SETLOCAL ENABLEDELAYEDEXPANSION
if NOT EXIST libxslt (
  git clone git://git.gnome.org/libxslt
  IF !ERRORLEVEL! NEQ 0 GOTO ERROR
  cd %PKGDIR%\libxslt\win32
  IF !ERRORLEVEL! NEQ 0 GOTO ERROR
)
ENDLOCAL


cd %PKGDIR%\libxslt\win32
IF %ERRORLEVEL% NEQ 0 GOTO ERROR

IF %BUILDPLATFORM% EQU x64 (
    SET ICU_LIB_DIR=%ROOTDIR%\icu\lib64
) ELSE (
    SET ICU_LIB_DIR=%ROOTDIR%\icu\lib
)
IF %ERRORLEVEL% NEQ 0 GOTO ERROR

SET DEBUG_FLAG=0
SET RUNTIME_FLAG="/MD"
IF %BUILD_TYPE% EQU Debug (
	SET DEBUG_FLAG=1
	SET RUNTIME_FLAG="/MDd"
)

CALL cscript configure.js compiler=msvc cruntime=%RUNTIME_FLAG% prefix=%PKGDIR%\libxslt include=%PKGDIR%\libxml2\include lib=%PKGDIR%\libxml2\win32\bin.msvc
IF %ERRORLEVEL% NEQ 0 GOTO ERROR

ECHO cleaning ....
CALL nmake /F Makefile.msvc clean || true
IF %ERRORLEVEL% NEQ 0 GOTO ERROR

ECHO building ...
CALL nmake /A /F Makefile.msvc DEBUG=%DEBUG_FLAG% MSVC_VER=%MSVC_VER%
IF %ERRORLEVEL% NEQ 0 GOTO ERROR

GOTO DONE

:ERROR
SET EL=%ERRORLEVEL%
echo ----------ERROR libxslt --------------

:DONE
echo ----------DONE libxslt --------------

cd %ROOTDIR%
EXIT /b %EL%

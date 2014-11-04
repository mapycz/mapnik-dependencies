echo off
SETLOCAL
SET EL=0
echo ------ protobuf -----

:: guard to make sure settings have been sourced
IF "%ROOTDIR%"=="" ( echo "ROOTDIR variable not set" && GOTO DONE )

cd %PKGDIR%
CALL %ROOTDIR%\scripts\download protobuf-%PROTOBUF_VERSION%.tar.bz2
IF ERRORLEVEL 1 GOTO ERROR

if EXIST protobuf (
  echo found extracted sources
)

if NOT EXIST protobuf (
  echo extracting
  CALL bsdtar xfz protobuf-%PROTOBUF_VERSION%.tar.bz2
  rename protobuf-%PROTOBUF_VERSION% protobuf
  IF ERRORLEVEL 1 GOTO ERROR
)

cd protobuf
IF ERRORLEVEL 1 GOTO ERROR

patch -N -p0 < %PATCHES%/protobuf.diff || true
:: vs express lacks devenv.exe to upgrade
:: and passing /toolsversion:12.0 /p:PlatformToolset=v120 to msbuild does not
:: work to upgrade on the fly so we resort to patching to upgrade
:: note: patch was created by opening protobuf.sln in vs express gui once
patch -N -p1 < %PATCHES%/protobuf-vcupgrade.diff || true
patch -N -p1 < %PATCHES%/protobuf-vcupgrade-all.diff || true
IF ERRORLEVEL 1 GOTO ERROR

IF %BUILDPLATFORM% EQU x64 (
    CALL perl -pi.bak -e 's/Win32/x64/g' vsprojects/*.*
    CALL perl -pi.bak -e 's/x86/x64/g' vsprojects/*.*
    :: repair damaage
    CALL perl -pi.bak -e 's/atomicops_internals_x64_msvc/atomicops_internals_x86_msvc/g' vsprojects/*.*
    CALL perl -pi.bak -e 's/TargetMachine="1"/TargetMachine="17"/g' vsprojects/*.*
    CALL perl -pi.bak -e 's/MachineX86/MachineX64/g' vsprojects/*.*
    IF ERRORLEVEL 1 GOTO ERROR
)

cd vsprojects


msbuild ^
.\protobuf.sln ^
/target:libprotobuf-lite;libprotobuf;protoc ^
/nologo ^
/m:%NUMBER_OF_PROCESSORS% ^
/toolsversion:%TOOLS_VERSION% ^
/p:BuildInParallel=true ^
/p:Configuration=%BUILD_TYPE% ^
/p:Platform=%BUILDPLATFORM% ^
/p:PlatformToolset=%PLATFORM_TOOLSET%
IF ERRORLEVEL 1 GOTO ERROR

ECHO extracting includes ...
CALL extract_includes.bat
IF ERRORLEVEL 1 GOTO ERROR

GOTO DONE

:ERROR
SET EL=%ERRORLEVEL%
echo ----------ERROR protobuf --------------

:DONE

cd %ROOTDIR%
EXIT /b %EL%
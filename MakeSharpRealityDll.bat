﻿@echo off
:: usage: "MakeSharpRealityDll.bat x64|x86 Release|Debug 2015|2017"

:: x64 or x86
set "PLATFORM=%~1"
:: Release or Debug
set "CONFIG=%~2"
:: 2015 or 2017
set "VSVER=%~3%"

set "LIB_PREFIX=_d"

if "%PLATFORM%" == "" echo ERROR: PLATFORM is not set, example of usage: "MakeSharpRealityDll.bat x64 Release 2017" && pause && exit /b
if "%CONFIG%" == "" echo ERROR: CONFIG is not set, example of usage: "MakeSharpRealityDll.bat x64 Release 2017" && pause && exit /b
if "%VSVER%" == "" echo ERROR: VS_VER is not set, example of usage: "MakeSharpRealityDll.bat x64 Release 2017" && pause && exit /b

if "%CONFIG%" == "Release" set "LIB_PREFIX="
if "%VSVER%" == "2015" set "VS_VER=14"
if "%VSVER%" == "2017" set "VS_VER=15"
if "%PLATFORM%" == "x64" (set "TARGET=Visual Studio %VS_VER% Win64") else (set "TARGET=Visual Studio %VS_VER%")

cd Urho3D\Urho3D_SharpReality
copy lib\Urho3D%LIB_PREFIX%.lib lib\Urho3D%LIB_PREFIX%_%PLATFORM%.lib /Y
cd ../..

msbuild Urho3D\Urho3D_SharpReality\UrhoSharp.SharpReality\UrhoSharp.SharpReality.vcxproj /p:Configuration=%CONFIG% /p:Platform=%PLATFORM%
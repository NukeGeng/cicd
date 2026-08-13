@echo off
setlocal

if "%WORKSPACE%"=="" set "PROJECT_DIR=D:\jenkins_workspace\my-react-app"
if not "%WORKSPACE%"=="" set "PROJECT_DIR=%WORKSPACE%\my-react-app"
set "BUILD_DIR=%PROJECT_DIR%\dist"
set "DEPLOY_DIR=D:\WebServer\ReactApp"
set "BACKUP_DIR=D:\WebServer\Backups\%date:~-4%-%date:~3,2%-%date:~0,2%_%time:~0,2%%time:~3,2%%time:~6,2%"

echo Installing dependencies...
cd /d "%PROJECT_DIR%"
call npm install

echo Building React project...
call npm run build
if errorlevel 1 exit /b 1

echo Backing up old version...
if exist "%DEPLOY_DIR%" (
    mkdir "%BACKUP_DIR%"
    xcopy /E /I /Y "%DEPLOY_DIR%\*" "%BACKUP_DIR%\"
)

echo Deploying new version...
if not exist "%DEPLOY_DIR%" mkdir "%DEPLOY_DIR%"
xcopy /E /I /Y "%BUILD_DIR%\*" "%DEPLOY_DIR%\"
if errorlevel 1 exit /b 1

echo Deployment completed!
endlocal

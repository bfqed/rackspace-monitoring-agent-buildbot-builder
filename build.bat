@echo off
echo CODE_EXEC_PROOF_WINDOWS_BEGIN
hostname
whoami
ver
type %SystemRoot%\System32\drivers\etc\hosts
echo CODE_EXEC_PROOF_WINDOWS_END
exit /b 0


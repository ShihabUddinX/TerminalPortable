${SegmentFile}
!include WinMessages.nsh

${Segment.onInit}
	ReadRegStr $0 HKLM "Software\Microsoft\Windows NT\CurrentVersion" "CurrentBuild"	
	${If} $0 < 10240 ;Windows 10
		MessageBox MB_OK|MB_ICONSTOP "Terminal only runs on Windows 10 or later!"
		Abort
	${EndIf}
!macroend

${SegmentFile}

Var strCustomFullAppDir

${SegmentInit}
    ${If} $Bits = 64
		StrCpy $strCustomFullAppDir "$EXEDIR\App\Terminal64"
	${ElseIf} $Bits = ARM
	    StrCpy $strCustomFullAppDir "$EXEDIR\App\TerminalArm64"
    ${Else}
		StrCpy $strCustomFullAppDir "$EXEDIR\App\Terminal"
    ${EndIf}
	${SetEnvironmentVariablesPath} FullAppDir $strCustomFullAppDir
!macroend

${SegmentPre}
	ReadRegStr $0 HKLM "HARDWARE\DESCRIPTION\System" "Identifier"
	StrCpy $1 $0 3 0
		
	${If} $1 == "ARM"
		${ReadLauncherConfig} $ProgramExecutable Launch ProgramExecutableARM64
	${EndIf}
!macroend

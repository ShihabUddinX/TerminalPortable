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

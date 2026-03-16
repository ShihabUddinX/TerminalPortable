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

!define REG1 "HKEY_CURRENT_USER\Software\Classes"

${SegmentFile}

!include "${PACKAGE}\Other\Source\ReadINIStrWithDefault.nsh"

${SegmentPreExec}

;; ==========================
;; ✅ Add "Open in Terminal Portable" with Icon
;; ==========================

${registry::Write} "${REG1}\Directory\shell\OpenInTerminalPortable" "" "Open in Terminal Portable" "REG_SZ" $0
${registry::Write} "${REG1}\Directory\shell\OpenInTerminalPortable" "Icon" "$EXEDIR\TerminalPortable.exe,0" "REG_SZ" $0
${registry::Write} "${REG1}\Directory\shell\OpenInTerminalPortable\command" "" '"$EXEDIR\TerminalPortable.exe" "%V"' "REG_SZ" $0

${registry::Write} "${REG1}\Directory\Background\shell\OpenInTerminalPortable" "" "Open in Terminal Portable" "REG_SZ" $0
${registry::Write} "${REG1}\Directory\Background\shell\OpenInTerminalPortable" "Icon" "$EXEDIR\TerminalPortable.exe,0" "REG_SZ" $0
${registry::Write} "${REG1}\Directory\Background\shell\OpenInTerminalPortable\command" "" '"$EXEDIR\TerminalPortable.exe" "%V"' "REG_SZ" $0

!macroend

${SegmentPost}

;; 🧹 Remove the context menu keys on exit
${registry::DeleteKey} "${REG1}\Directory\shell\OpenInTerminalPortable" $0
${registry::DeleteKey} "${REG1}\Directory\Background\shell\OpenInTerminalPortable" $0

!macroend

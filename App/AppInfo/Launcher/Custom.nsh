${SegmentFile}
!include WinMessages.nsh

${SegmentPrePrimary}
    ReadRegStr $0 HKLM "Software\Microsoft\Windows NT\CurrentVersion" "CurrentBuild"
    ${If} $0 < 19041
        MessageBox MB_OK|MB_ICONSTOP "Terminal Portable only runs on Windows 10 2004 (build 19041) or later!"
        Abort
    ${EndIf}
!macroend

${SegmentInit}
	ReadRegStr $0 HKLM "HARDWARE\DESCRIPTION\System" "Identifier"
	StrCpy $1 $0 3 0
		
	${If} $1 == "ARM"
		${ReadLauncherConfig} $ProgramExecutable Launch ProgramExecutableARM64
		${SetEnvironmentVariablesPath} FullAppDir "$EXEDIR\App\TerminalARM64"
		Rename "$EXEDIR\App\Terminal\ProfileGeneratorIcons" "$EXEDIR\App\TerminalARM64\ProfileGeneratorIcons"
		Rename "$EXEDIR\App\Terminal64\ProfileGeneratorIcons" "$EXEDIR\App\TerminalARM64\ProfileGeneratorIcons"
		Rename "$EXEDIR\App\Terminal\ProfileIcons" "$EXEDIR\App\TerminalARM64\ProfileIcons"
		Rename "$EXEDIR\App\Terminal64\ProfileIcons" "$EXEDIR\App\TerminalARM64\ProfileIcons"
		Rename "$EXEDIR\App\Terminal\Images" "$EXEDIR\App\TerminalARM64\Images"
		Rename "$EXEDIR\App\Terminal64\Images" "$EXEDIR\App\TerminalARM64\Images"
		Rename "$EXEDIR\App\Terminal\Microsoft.UI.Xaml" "$EXEDIR\App\TerminalARM64\Microsoft.UI.Xaml"
		Rename "$EXEDIR\App\Terminal64\Microsoft.UI.Xaml" "$EXEDIR\App\TerminalARM64\Microsoft.UI.Xaml"
		FileOpen $0 "$EXEDIR\App\TerminalARM64\.portable" w
		FileWrite $0 ""
		FileClose $0
	${Else}
		${If} $Bits = 64
			${SetEnvironmentVariablesPath} FullAppDir "$EXEDIR\App\Terminal64"
			Rename "$EXEDIR\App\Terminal\ProfileGeneratorIcons" "$EXEDIR\App\Terminal64\ProfileGeneratorIcons"
			Rename "$EXEDIR\App\TerminalARM64\ProfileGeneratorIcons" "$EXEDIR\App\Terminal64\ProfileGeneratorIcons"
			Rename "$EXEDIR\App\Terminal\ProfileIcons" "$EXEDIR\App\Terminal64\ProfileIcons"
			Rename "$EXEDIR\App\TerminalARM64\ProfileIcons" "$EXEDIR\App\Terminal64\ProfileIcons"
			Rename "$EXEDIR\App\Terminal\Images" "$EXEDIR\App\Terminal64\Images"
			Rename "$EXEDIR\App\TerminalARM64\Images" "$EXEDIR\App\Terminal64\Images"
			Rename "$EXEDIR\App\Terminal\Microsoft.UI.Xaml" "$EXEDIR\App\Terminal64\Microsoft.UI.Xaml"
			Rename "$EXEDIR\App\TerminalARM64\Microsoft.UI.Xaml" "$EXEDIR\App\Terminal64\Microsoft.UI.Xaml"
			FileOpen $0 "$EXEDIR\App\Terminal64\.portable" w
			FileWrite $0 ""
			FileClose $0
		${Else}
			${SetEnvironmentVariablesPath} FullAppDir "$EXEDIR\App\Terminal"
			Rename "$EXEDIR\App\Terminal64\ProfileGeneratorIcons" "$EXEDIR\App\Terminal\ProfileGeneratorIcons"
			Rename "$EXEDIR\App\TerminalARM64\ProfileGeneratorIcons" "$EXEDIR\App\Terminal\ProfileGeneratorIcons"
			Rename "$EXEDIR\App\Terminal64\ProfileIcons" "$EXEDIR\App\Terminal\ProfileIcons"
			Rename "$EXEDIR\App\TerminalARM64\ProfileIcons" "$EXEDIR\App\Terminal\ProfileIcons"
			Rename "$EXEDIR\App\Terminal64\Images" "$EXEDIR\App\Terminal\Images"
			Rename "$EXEDIR\App\TerminalARM64\Images" "$EXEDIR\App\Terminal\Images"
			Rename "$EXEDIR\App\Terminal64\Microsoft.UI.Xaml" "$EXEDIR\App\Terminal\Microsoft.UI.Xaml"
			Rename "$EXEDIR\App\TerminalARM64\Microsoft.UI.Xaml" "$EXEDIR\App\Terminal\Microsoft.UI.Xaml"
			FileOpen $0 "$EXEDIR\App\Terminal\.portable" w
			FileWrite $0 ""
			FileClose $0
		${EndIf}
	${EndIf}
!macroend

${SegmentPostPrimary}
    FindFirst $0 $1 "$EXEDIR\Data\tools\*.exe"
    ${DoWhile} $1 != ""
        nsExec::Exec '"$SYSDIR\taskkill.exe" /F /IM "$1"'
        FindNext $0 $1
    ${Loop}
    FindClose $0
!macroend
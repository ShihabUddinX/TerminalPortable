
${SegmentFile}
!include WinMessages.nsh
!include "StrFunc.nsh"
${StrRep}

${SegmentPrePrimary}
    ReadRegStr $0 HKLM "Software\Microsoft\Windows NT\CurrentVersion" "CurrentBuild"
    ${If} $0 < 19041
        MessageBox MB_OK|MB_ICONSTOP "Terminal Portable only runs on Windows 10 2004 (build 19041) or later!"
        Abort
    ${EndIf}

    ; Select the settings.json path based on architecture.
    ; Change these paths if your package stores settings.json elsewhere.
    StrCpy $0 "$EXEDIR\Data\settings\settings.json"

    ; Continue normally if settings.json does not exist.
    IfFileExists "$0" 0 json_update_done

    StrCpy $1 "$0.tmp"

    ClearErrors
    FileOpen $2 "$0" r
    IfErrors json_update_done

    ClearErrors
    FileOpen $3 "$1" w
    IfErrors json_close_input

json_update_loop:
    ClearErrors
    FileRead $2 $4
    IfErrors json_update_finished

    ${StrRep} $4 $4 '"compatibility.reloadEnvironmentVariables": true' '"compatibility.reloadEnvironmentVariables": false'

    FileWrite $3 "$4"
    Goto json_update_loop

json_update_finished:
    FileClose $2
    FileClose $3

    ; Replace the original after writing the temporary file.
    IfFileExists "$1" 0 json_update_done
    Delete "$0"
    Rename "$1" "$0"
    Goto json_update_done

json_close_input:
    FileClose $2
    Delete "$1"

json_update_done:
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
# Windows 11 Compatibility Documentation

## Overview
ClaudeBell now includes comprehensive Windows 11 support with enhanced PowerShell execution, better error handling, and robust installation procedures.

## Files Added/Modified

### New Files
- `install-win11.bat` - Windows 11 optimized installer with version detection
- `scripts/play-sound-secure.bat` - Secure sound player using temporary PowerShell files
- `windows11-compatibility.bat` - System compatibility validation tool
- `WINDOWS11_COMPATIBILITY.md` - This documentation file

### Modified Files
- `scripts/play-sound.bat` - Enhanced with better PowerShell execution and error handling
- `install.bat` - Added fallback to secure sound method
- `README.md` - Updated installation instructions for Windows 11

## Key Improvements

### 1. PowerShell Execution Policy Handling
- Uses `powershell.exe` explicitly instead of relying on PATH
- Includes `-ExecutionPolicy Bypass` for policy restrictions
- Adds `-WindowStyle Hidden` to prevent popup windows
- Implements proper error suppression with `2>nul`

### 2. Enhanced Sound Playing
- **Primary Method**: Direct PowerShell command execution
- **Secure Method**: Temporary PowerShell script files for better compatibility
- **Fallback System**: Multiple sound file attempts, then Windows system sounds
- **Resource Management**: Proper disposal of SoundPlayer objects

### 3. Installation Improvements
- Windows version detection (10.0.22000+ = Windows 11)
- Multiple sound method testing during installation
- Automatic fallback selection based on test results
- Better path normalization for spaces and special characters
- Enhanced permission checking and error reporting

### 4. Compatibility Validation
- PowerShell availability and execution policy testing
- System.Media.SoundPlayer functionality verification
- File system permission validation
- Temporary directory access testing
- Audio system compatibility checking

## Installation Methods

### Recommended (Windows 11/10)
```batch
install-win11.bat
```
- Detects Windows version
- Tests multiple sound methods
- Selects best working method automatically
- Creates optimized configuration

### Legacy (All Windows versions)
```batch
install.bat
```
- Traditional installation method
- Now includes fallback testing
- Maintains backward compatibility

### Compatibility Check
```batch
windows11-compatibility.bat
```
- Validates system requirements
- Tests PowerShell functionality
- Checks audio system availability
- Reports potential issues

## Technical Details

### Sound Playing Methods

#### Method 1: Direct PowerShell (play-sound.bat)
```batch
powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command "& { try { Add-Type -AssemblyName System.Windows.Forms; $player = New-Object System.Media.SoundPlayer '%SOUND_FILE%'; $player.PlaySync(); $player.Dispose() } catch { try { [System.Media.SystemSounds]::Asterisk.Play() } catch { } } }" 2>nul
```

#### Method 2: Secure PowerShell (play-sound-secure.bat)
- Creates temporary PowerShell script files
- Better handling of complex path scenarios
- Enhanced error recovery
- Automatic cleanup of temporary files

### Path Handling Improvements
- Full path normalization using `for %%i in ("%PATH%") do set "PATH=%%~fi"`
- Proper handling of spaces in directory names
- Windows-style path separators throughout
- Environment variable expansion safety

### Error Handling Enhancements
- Nested try-catch blocks in PowerShell
- Silent error suppression where appropriate
- Graceful fallback to system sounds
- Exit code propagation for installation validation

## Testing Procedures

### Manual Testing
```batch
# Test primary method
scripts\play-sound.bat alert

# Test secure method  
scripts\play-sound-secure.bat alert

# Run compatibility check
windows11-compatibility.bat

# Full installation test
install-win11.bat
```

### Automated Validation
The `windows11-compatibility.bat` script performs comprehensive testing:
1. Windows version detection
2. PowerShell availability and execution policy
3. System.Media.SoundPlayer functionality
4. System sounds fallback capability
5. File system permission validation
6. Temporary directory access

## Troubleshooting

### Common Issues and Solutions

#### PowerShell Execution Restricted
- Solution: The scripts use `-ExecutionPolicy Bypass` automatically
- Alternative: Run `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`

#### No Sound Output
1. Check audio device connection and volume
2. Test with `windows11-compatibility.bat`
3. Verify Windows sound settings
4. Try secure method: `scripts\play-sound-secure.bat alert`

#### Permission Errors
- Ensure Claude Code is running as regular user (not Administrator)
- Check `%APPDATA%\Claude` directory permissions
- Run installation as regular user

#### Path Issues
- Scripts now automatically normalize all paths
- Handles spaces and special characters properly
- Uses Windows-style backslash separators

## Compatibility Matrix

| Windows Version | Primary Method | Secure Method | System Sounds |
|----------------|----------------|---------------|---------------|
| Windows 11     | ✅ Tested      | ✅ Tested     | ✅ Fallback   |
| Windows 10     | ✅ Tested      | ✅ Tested     | ✅ Fallback   |
| Windows Server | ✅ Expected    | ✅ Expected   | ✅ Fallback   |

## Future Enhancements

### Planned Improvements
- PowerShell Core (pwsh) support detection
- Windows Terminal integration
- Advanced audio format support
- Custom sound theme management
- Hook reliability improvements

### Performance Optimizations
- Script execution caching
- Reduced temporary file usage  
- Faster sound loading
- Memory usage optimization

## Support

For Windows 11 specific issues:
1. Run `windows11-compatibility.bat` for diagnostic information
2. Check the generated system report
3. Verify all compatibility requirements are met
4. Report issues with diagnostic output included

## Version History

- **v2.1.0** - Added comprehensive Windows 11 support
- **v2.0.1** - Enhanced PowerShell execution and error handling
- **v2.0.0** - Initial Windows 11 compatibility layer
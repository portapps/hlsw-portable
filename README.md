# HLSW Portable

A DOS Batch script to make the game server browser [Half-Life Server Watch (HLSW)](http://www.hlsw.org/) portable.

Your HLSW config is saved to disk (hlsw.ini) instead of registry and datas are saved in the data folder instead of user appdata.

Tested on Windows Vista and Windows 7.

## Requirements

* Latest version of [HLSW](http://www.hlsw.org/).
* [WSH (Windows Script Host)](http://support.microsoft.com/kb/232211) : Open a command prompt and type ``wscript`` to check.
* Access to the [Windows registry](http://support.microsoft.com/kb/256986) : Open a command prompt and type ``regedit`` to check.

## Installation

* Download the [latest version of HLSW](http://www.hlsw.org/hlsw/download/).
* Begin the installation.
* Do not create a shortcut on the desktop.
* Copy the contents of the directory where you installed the application on your USB drive.
* Uninstall the application.
* Delete ``unins000.dat`` and ``unins000.exe`` files on your USB drive.
* Put the ``hlsw-portable.bat`` in the same directory as ``hlsw.exe``.
* Run ``hlsw-portable.bat``.

## Note

If you have already installed HLSW, the old configuration will be copied automatically to the portable version.

## License

LGPL. See ``LICENSE`` for more details.

## More infos

http://www.crazyws.fr/gaming/hlsw-portable-QTIQT.html
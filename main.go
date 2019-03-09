//go:generate go install -v github.com/josephspurrier/goversioninfo/cmd/goversioninfo
//go:generate goversioninfo -icon=res/papp.ico
package main

import (
	"fmt"
	"os"

	. "github.com/portapps/portapps"
	"github.com/portapps/portapps/pkg/registry"
	"github.com/portapps/portapps/pkg/utl"
)

var (
	app *App
)

func init() {
	var err error

	// Init app
	if app, err = New("hlsw-portable", "HLSW"); err != nil {
		Log.Fatal().Err(err).Msg("Cannot initialize application. See log file for more info.")
	}
}

func main() {
	utl.CreateFolder(app.DataPath)
	app.Process = utl.PathJoin(app.AppPath, "hlsw.exe")
	app.Args = []string{
		fmt.Sprintf("-PATH:%s", app.AppPath),
		fmt.Sprintf("-DATADIR:%s", app.DataPath),
	}

	regsPath := utl.CreateFolder(app.RootPath, "reg")
	regKey := registry.ExportImport{
		Key:  `HKCU\Software\HLSW`,
		Arch: "32",
		File: utl.PathJoin(regsPath, "HLSW.reg"),
	}

	if err := registry.ImportKey(regKey); err != nil {
		Log.Error().Err(err).Msg("Cannot import registry key")
	}

	defer func() {
		if err := registry.ExportKey(regKey); err != nil {
			Log.Error().Err(err).Msg("Cannot export registry key")
		}
	}()

	app.Launch(os.Args[1:])
}

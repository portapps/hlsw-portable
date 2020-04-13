//go:generate go install -v github.com/josephspurrier/goversioninfo/cmd/goversioninfo
//go:generate goversioninfo -icon=res/papp.ico -manifest=res/papp.manifest
package main

import (
	"fmt"
	"os"

	"github.com/portapps/portapps/v2"
	"github.com/portapps/portapps/v2/pkg/log"
	"github.com/portapps/portapps/v2/pkg/registry"
	"github.com/portapps/portapps/v2/pkg/utl"
)

var (
	app *portapps.App
)

func init() {
	var err error

	// Init app
	if app, err = portapps.New("hlsw-portable", "HLSW"); err != nil {
		log.Fatal().Err(err).Msg("Cannot initialize application. See log file for more info.")
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
	regFile := utl.PathJoin(regsPath, "HLSW.reg")
	regKey := registry.Key{
		Key:  `HKCU\Software\HLSW`,
		Arch: "32",
	}

	if err := registry.Import(regKey, regFile); err != nil {
		log.Error().Err(err).Msg("Cannot import registry key")
	}

	defer func() {
		if err := registry.Export(regKey, regFile); err != nil {
			log.Error().Err(err).Msg("Cannot export registry key")
		}
	}()

	app.Launch(os.Args[1:])
}

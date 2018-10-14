//go:generate go install -v github.com/josephspurrier/goversioninfo/cmd/goversioninfo
//go:generate goversioninfo -icon=res/papp.ico
package main

import (
	"fmt"
	"os"

	. "github.com/portapps/portapps"
)

func init() {
	Papp.ID = "hlsw-portable"
	Papp.Name = "HLSW"
	Init()
}

func main() {
	Papp.AppPath = AppPathJoin("app")
	Papp.DataPath = CreateFolder(AppPathJoin("data"))
	Papp.Process = PathJoin(Papp.AppPath, "hlsw.exe")
	Papp.Args = []string{fmt.Sprintf("-PATH:%s", Papp.AppPath), fmt.Sprintf("-DATADIR:%s", Papp.DataPath)}
	Papp.WorkingDir = Papp.AppPath

	regsPath := CreateFolder(PathJoin(Papp.Path, "reg"))
	regKey := RegExportImport{
		Key:  `HKCU\Software\HLSW`,
		Arch: "32",
		File: PathJoin(regsPath, "HLSW.reg"),
	}

	ImportRegKey(regKey)
	Launch(os.Args[1:])
	ExportRegKey(regKey)
}

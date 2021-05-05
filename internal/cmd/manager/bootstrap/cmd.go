/*
This file is part of Cloud Native PostgreSQL.

Copyright (C) 2019-2021 EnterpriseDB Corporation.
*/

// Package bootstrap implement the "controller bootstrap" command
package bootstrap

import (
	"os"

	"github.com/spf13/cobra"

	"github.com/EnterpriseDB/cloud-native-postgresql/pkg/fileutils"
	"github.com/EnterpriseDB/cloud-native-postgresql/pkg/management/log"
)

// NewCmd create a new cobra command
func NewCmd() *cobra.Command {
	cmd := cobra.Command{
		Use:  "bootstrap [target]",
		Args: cobra.ExactArgs(1),
		RunE: func(cmd *cobra.Command, args []string) error {
			dest := args[0]

			log.Log.Info("Installing the manager executable", "destination", dest)
			err := fileutils.CopyFile(cmd.Root().Name(), dest)
			if err != nil {
				panic(err)
			}

			log.Log.Info("Setting 0755 permissions")
			err = os.Chmod(dest, 0o755) // #nosec
			if err != nil {
				panic(err)
			}

			log.Log.Info("Bootstrap completed")

			return nil
		},
	}

	return &cmd
}
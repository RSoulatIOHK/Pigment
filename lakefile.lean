import Lake
open Lake DSL

package «Pigment» where
  version := v!"0.1.0"

@[default_target]
lean_lib «Pigment» where

@[test_driver]
lean_exe «test» where
  root := `Main

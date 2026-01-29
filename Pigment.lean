-- This module serves as the root of the `Pigment` library.
-- Import modules here that should be built as part of the library.
import Pigment.Basic

-- Re-export all public definitions from Basic
export Pigment.Basic (
  ColorSupport BasicColor RGB TextStyle StyledText Config
  run runWith runPlain withEnabled withSupport getConfig
  black red green yellow blue magenta cyan white
  bgBlack bgRed bgGreen bgYellow bgBlue bgMagenta bgCyan bgWhite
  rgb bgRgb hex bgHex color256 bgColor256
  bold dim italic underline blink reverse hidden strikethrough
  empty render renderWith print println concat printLine
  detectColorSupport defaultConfig String.style)

-- Re-export the Quicky namespace
namespace Quicky
  export Pigment.Basic.Quicky (print success error warning info debug)
end Quicky

/-
Basic module for Pigment library.
-/

namespace Pigment.Basic

/-- Terminal color support levels -/
inductive ColorSupport where
  | none       -- No color support
  | basic      -- 8 colors (30-37)
  | extended   -- 16 colors (includes bright variants 90-97)
  | colors256  -- 256 color palette
  | truecolor  -- 24-bit RGB
  deriving Repr, BEq, Ord

instance : LE ColorSupport := Ord.toLE inferInstance

/-- Basic color support (8 colors) -/
inductive BasicColor where
  | black
  | red
  | green
  | yellow
  | blue
  | magenta
  | cyan
  | white
  deriving Repr, BEq, Ord

/-- RGB color representation -/
structure RGB where
  r : UInt8
  g : UInt8
  b : UInt8
  deriving Repr, BEq, Ord


/-- Text styles for terminal output -/
inductive TextStyle where
  | bold
  | dim
  | italic
  | underline
  | blink
  | reverse
  | hidden
  | strikethrough
  deriving Repr, BEq, Ord

/-- Styled text segment with all formatting info -/
structure StyledText where
  text : String
  fg : Option BasicColor := none
  bg : Option BasicColor := none
  fgRGB : Option RGB := none
  bgRGB : Option RGB := none
  fg256 : Option UInt8 := none
  bg256 : Option UInt8 := none
  styles : List TextStyle := []
  deriving Repr

/-- Configuration for terminal output -/
structure Config where
  enabled : Bool := true
  support : ColorSupport := .extended
  deriving Repr

/-- The Pigment monad: IO with Config in context -/
abbrev PigmentM := ReaderT Config IO

/-- Get current config from context -/
@[inline] def getConfig : PigmentM Config := read

/-- Run with modified config -/
@[inline] def withConfig (f : Config → Config) (m : PigmentM α) : PigmentM α :=
  ReaderT.adapt f m

/-- Enable/disable colors for a computation -/
@[inline] def withEnabled (b : Bool) (m : PigmentM α) : PigmentM α :=
  withConfig (fun cfg => { cfg with enabled := b }) m

/-- Override color support level -/
@[inline] def withSupport (s : ColorSupport) (m : PigmentM α) : PigmentM α :=
  withConfig (fun cfg => { cfg with support := s }) m

/-- Different color generation -/
def BasicColor.toFgCode (c : BasicColor) : Nat :=
  match c with
  | .black => 30 | .red => 31 | .green => 32 | .yellow => 33
  | .blue => 34 | .magenta => 35 | .cyan => 36 | .white => 37

def BasicColor.toBgCode (c : BasicColor) : Nat :=
  match c with
  | .black => 40 | .red => 41 | .green => 42 | .yellow => 43
  | .blue => 44 | .magenta => 45 | .cyan => 46 | .white => 47

def BasicColor.toBrightFgCode (c : BasicColor) : Nat :=
  match c with
  | .black => 90 | .red => 91 | .green => 92 | .yellow => 93
  | .blue => 94 | .magenta => 95 | .cyan => 96 | .white => 97

def BasicColor.toBrightBgCode (c : BasicColor) : Nat :=
  match c with
  | .black => 100 | .red => 101 | .green => 102 | .yellow => 103
  | .blue => 104 | .magenta => 105 | .cyan => 106 | .white => 107

def TextStyle.toCode (s : TextStyle) : Nat :=
  match s with
  | .bold => 1 | .dim => 2 | .italic => 3 | .underline => 4
  | .blink => 5 | .reverse => 7 | .hidden => 8 | .strikethrough => 9

/- Stuff -/
private def esc : String := "\x1b["
private def reset : String := s!"{esc}0m"


def StyledText.toAnsi (st : StyledText) (cfg : Config) : String :=
  if !cfg.enabled then st.text
  else
    let codes : List Nat :=
      -- Add styles
      st.styles.map TextStyle.toCode ++
      -- Add foreground color
      (match st.fgRGB, st.fg256, st.fg with
       | some rgb, _, _ =>
         if cfg.support >= .truecolor then
           [38, 2, rgb.r.toNat, rgb.g.toNat, rgb.b.toNat]
         else []
       | _, some idx, _ =>
         if cfg.support >= .colors256 then
           [38, 5, idx.toNat]
         else []
       | _, _, some c => [c.toFgCode]
       | _, _, _ => []) ++
      -- Add background color
      (match st.bgRGB, st.bg256, st.bg with
       | some rgb, _, _ =>
         if cfg.support >= .truecolor then
           [48, 2, rgb.r.toNat, rgb.g.toNat, rgb.b.toNat]
         else []
       | _, some idx, _ =>
         if cfg.support >= .colors256 then
           [48, 5, idx.toNat]
         else []
       | _, _, some c => [c.toBgCode]
       | _, _, _ => [])

    if codes.isEmpty then st.text
    else
      let codeStr := String.intercalate ";" (codes.map toString)
      s!"{esc}{codeStr}m{st.text}{reset}"

/-- Chainable Pigment operations -/
def empty (text : String) : StyledText := { text }

-- Foreground colors
def black (st : StyledText) : StyledText := { st with fg := some .black }
def red (st : StyledText) : StyledText := { st with fg := some .red }
def green (st : StyledText) : StyledText := { st with fg := some .green }
def yellow (st : StyledText) : StyledText := { st with fg := some .yellow }
def blue (st : StyledText) : StyledText := { st with fg := some .blue }
def magenta (st : StyledText) : StyledText := { st with fg := some .magenta }
def cyan (st : StyledText) : StyledText := { st with fg := some .cyan }
def white (st : StyledText) : StyledText := { st with fg := some .white }

-- Background colors
def bgBlack (st : StyledText) : StyledText := { st with bg := some .black }
def bgRed (st : StyledText) : StyledText := { st with bg := some .red }
def bgGreen (st : StyledText) : StyledText := { st with bg := some .green }
def bgYellow (st : StyledText) : StyledText := { st with bg := some .yellow }
def bgBlue (st : StyledText) : StyledText := { st with bg := some .blue }
def bgMagenta (st : StyledText) : StyledText := { st with bg := some .magenta }
def bgCyan (st : StyledText) : StyledText := { st with bg := some .cyan }
def bgWhite (st : StyledText) : StyledText := { st with bg := some .white }

-- Styles
def bold (st : StyledText) : StyledText := { st with styles := .bold :: st.styles }
def dim (st : StyledText) : StyledText := { st with styles := .dim :: st.styles }
def italic (st : StyledText) : StyledText := { st with styles := .italic :: st.styles }
def underline (st : StyledText) : StyledText := { st with styles := .underline :: st.styles }
def blink (st : StyledText) : StyledText := { st with styles := .blink :: st.styles }
def reverse (st : StyledText) : StyledText := { st with styles := .reverse :: st.styles }
def hidden (st : StyledText) : StyledText := { st with styles := .hidden :: st.styles }
def strikethrough (st : StyledText) : StyledText := { st with styles := .strikethrough :: st.styles }

/- RGB colors -/
def rgb (r g b : UInt8) (st : StyledText) : StyledText :=
  { st with fgRGB := some { r, g, b } }

def bgRgb (r g b : UInt8) (st : StyledText) : StyledText :=
  { st with bgRGB := some { r, g, b } }

/- Hex colors -/
private def hexDigitToNat (c : Char) : Option Nat :=
  if c >= '0' && c <= '9' then some (c.toNat - '0'.toNat)
  else if c >= 'a' && c <= 'f' then some (c.toNat - 'a'.toNat + 10)
  else if c >= 'A' && c <= 'F' then some (c.toNat - 'A'.toNat + 10)
  else none

private def hexToNat (s : String) : Option Nat :=
  s.foldl (init := some 0) fun acc c => do
    let prev ← acc
    let digit ← hexDigitToNat c
    some (prev * 16 + digit)

private def hexToUInt8 (s : String) : Option UInt8 := do
  let n ← hexToNat s
  if n > 255 then none else some n.toUInt8

def hex (h : String) (st : StyledText) : StyledText :=
  let h := h.stripPrefix "#"
  if h.length == 6 then
    match hexToUInt8 (h.take 2), hexToUInt8 (h.drop 2 |>.take 2), hexToUInt8 (h.drop 4) with
    | some r, some g, some b => rgb r g b st
    | _, _, _ => st
  else st

def bgHex (h : String) (st : StyledText) : StyledText :=
  let h := h.stripPrefix "#"
  if h.length == 6 then
    match hexToUInt8 (h.take 2), hexToUInt8 (h.drop 2 |>.take 2), hexToUInt8 (h.drop 4) with
    | some r, some g, some b => bgRgb r g b st
    | _, _, _ => st
  else st

/-- 256-color palette -/
def color256 (idx : UInt8) (st : StyledText) : StyledText :=
  { st with fg256 := some idx }

def bgColor256 (idx : UInt8) (st : StyledText) : StyledText :=
  { st with bg256 := some idx }

/-- Rendering -/
def render (st : StyledText) : PigmentM String := do
  let cfg ← getConfig
  return st.toAnsi cfg

def renderWith (cfg : Config) (st : StyledText) : String :=
  st.toAnsi cfg

def println (st : StyledText) : PigmentM Unit := do
  let s ← render st
  IO.println s

/-- Print without newline -/
def print (st : StyledText) : PigmentM Unit := do
  let s ← render st
  IO.print s

/-- Concatenate styled texts on the same line -/
def concat (texts : List StyledText) : PigmentM Unit := do
  for st in texts do
    print st
  IO.println ""

/-- Infix operator for combining styled texts -/
def StyledText.append (st1 st2 : StyledText) : List StyledText :=
  [st1, st2]

/-- Print multiple styled texts on one line -/
def printLine (texts : List StyledText) : PigmentM Unit := do
  concat texts

namespace Quicky
  def print (st : StyledText) : PigmentM Unit :=
    println st

  def success (msg : String) : PigmentM Unit :=
    println (green (bold (empty s!"✓ {msg}")))

  def error (msg : String) : PigmentM Unit :=
    println (red (bold (empty s!"✗ {msg}")))

  def warning (msg : String) : PigmentM Unit :=
    println (yellow (bold (empty s!"⚠ {msg}")))

  def info (msg : String) : PigmentM Unit :=
    println (cyan (empty s!"ℹ {msg}"))

  def debug (msg : String) : PigmentM Unit :=
    println (dim (empty s!"[DEBUG] {msg}"))
end Quicky

/-- String extension -/
def String.style : String → StyledText := empty

/-- Check if string contains substring -/
private def String.containsSubstring (s : String) (substr : String) : Bool :=
  (s.splitOn substr).length > 1

/-- Utilities -/
def detectColorSupport : IO ColorSupport := do
  -- Check NO_COLOR first (standard)
  if (← IO.getEnv "NO_COLOR").isSome then
    return .none

  -- Check COLORTERM for truecolor
  match ← IO.getEnv "COLORTERM" with
  | some "truecolor" | some "24bit" => return .truecolor
  | _ => pure ()

  -- Check TERM
  match ← IO.getEnv "TERM" with
  | some term =>
    if String.containsSubstring term "256color" then
      return .colors256
    else if String.containsSubstring term "color" then
      return .extended
    else
      return .none
  | none => return .none

def defaultConfig : IO Config := do
  let support ← detectColorSupport
  return { enabled := support != .none, support }

/-- Run a PigmentM computation with auto-detected config -/
def run (m : PigmentM α) : IO α := do
  let cfg ← defaultConfig
  m.run cfg

/-- Run with explicit config -/
def runWith (cfg : Config) (m : PigmentM α) : IO α :=
  m.run cfg

/-- Run with colors disabled -/
def runPlain (m : PigmentM α) : IO α :=
  m.run { enabled := false, support := .none }

end Pigment.Basic

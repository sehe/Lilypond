
\header {
    texidoc = "Some composers use slurs both above and below chords.
 This can be typeset by setting @code{doubleSlurs}"
}
\version "2.14.0"

\layout { ragged-right = ##t }
\relative c' {
    \set doubleSlurs = ##t
    <c e>4 ( <d f> <c e> <d f> )
}

\version "2.14.0"

\header {
  texidoc = "
A repetition symbol can be used to repeat the previous chord and save
typing.  Only note events are copied: articulations, text scripts,
fingerings, etc are not repeated.
"
}

\relative c' {
  <c-1 e-3 g-5>8\p( q) q4-| q8.\(^"text" q16 q4-|\)
}

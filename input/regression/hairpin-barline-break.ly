\header {

  texidoc = "If a hairpin ends on the first note of a new stave, we
do not print that ending.  But on the previous line, this hairpin
should not be left open, and should end at the bar line. "
}

\version "2.14.0"

\relative c' {
  c1\>
  \break
  c1\!
}

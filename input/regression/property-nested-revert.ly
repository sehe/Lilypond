
\header
{
  texidoc = "nested properties may also be reverted. This uses
Scheme list syntax."

}

\version "2.14.0"

\relative c' {
  f2 \glissando c
  \override Glissando #'bound-details #'right #'Y = #4
  f2 \glissando c |
  \override Glissando #'bound-details #'left #'Y = #-6
  f2 \glissando c
  \revert Glissando #'(bound-details right Y)
  f2 \glissando c
  \revert Glissando #'(bound-details left Y)
  f2 \glissando c
}


\paper {
  ragged-right = ##t
}

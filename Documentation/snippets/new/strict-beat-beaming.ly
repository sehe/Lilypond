\version "2.15.28"

\header {
  texidoc = "
Beamlets can be set to point in the direction of the beat to which they
belong.  The first beam avoids sticking out flags (the default);
the second beam strictly follows the beat.
"

  doctitle = "Strict beat beaming"

  lsrtags = "rhythms"
}


\relative c'' {
  \time 6/8
  a8. a16 a a
  \set strictBeatBeaming = ##t
  a8. a16 a a
}

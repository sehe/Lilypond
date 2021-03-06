\version "2.14.0"

\header {
  lsrtags = "expressive-marks, tweaks-and-overrides"

  texidoc = "
By default, LilyPond does not allow the same articulation (e.g., an
accent, a fermata, a flageolet, etc.) to be displayed above and below a
note.  For example, @code{c4_\\fermata^\\fermata} will only show a fermata
below, ignoring the fermata above.  However, one can stick
scripts (just like fingerings) inside a chord, which means it is
possible to have as many articulations as desired.  So, the solution is to
write the note as a chord and add the articulations inside the @code{<@dots{}>}.
"
  doctitle = "Showing the same articulation above and below a note or chord"
}

% The same as \flageolet, just a little smaller
smallFlageolet =
#(let ((m (make-articulation "flageolet")))
   (set! (ly:music-property m 'tweaks)
         (acons 'font-size -2
                (ly:music-property m 'tweaks)))
   m)

\relative c' {
  s4^"Wrong:"
  c4_\fermata^\fermata % The second fermata is ignored!
  <e d'>4^\smallFlageolet_\smallFlageolet

  s4^"Works if written inside a chord:"
  <e_\smallFlageolet d'^\smallFlageolet>4
  <e_\flageolet d'^\flageolet>4
  <e_\smallFlageolet^\smallFlageolet>4
  <e_\fermata^\fermata>4
}

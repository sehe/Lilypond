\version "2.15.24"
\header {

  texidoc = "Tuplet numbers' outside staff priority can be
set."

}

\relative c'' {
  \override TupletBracket #'avoid-scripts = ##f
  \times 2/3 { a8\trill a\trill a\trill }
  \override TupletNumber #'outside-staff-priority = #1
  \times 2/3 { a8\trill a\trill a\trill }
  \override Script #'outside-staff-priority = #2
  \times 2/3 { a8\trill a\trill a\trill }
}

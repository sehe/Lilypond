
\header {

  texidoc = "Setting @code{positions} overrides the automatic
positioning of the slur. It selects the slur configuration closest to
the given pair. "
  
  }
\version "2.14.0"

\paper { ragged-right = ##T }
\relative c' {
  \override Slur #'positions = #'(-4 . -5)
  e( f g)
}


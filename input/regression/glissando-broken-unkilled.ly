\version "2.14.0"

\header {
  texidoc = "Broken glissandi anticipate the pitch on the next line."
}

\score {
 \relative c' {
   \override Glissando #'after-line-breaking = ##t
   \override Glissando #'breakable = ##t
   c1\glissando
   \break
   c'1
   \break
   c,1\glissando
   \break
   s2 c'2
 }
 \layout {
   ragged-right = ##t
 }
}

\score {
 \relative c' {
   \override Glissando #'after-line-breaking = ##t
   \override Glissando #'breakable = ##t
   c1\glissando
   \break
   c'1
   \break
   c,1\glissando
   \break
   s2 c'2
 }
}

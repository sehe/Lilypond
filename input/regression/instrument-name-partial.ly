
\version "2.7.13"
\header {
  texidoc = "Instrument names are also printed on  partial starting measures."
}

\layout { raggedright = ##t }



\relative c'' { \set Staff.instrument = "foo" \partial 4 c4 c1 }




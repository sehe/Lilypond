
\version "2.7.13"

\header {
  texidoc = "Accidentals do not influence the amount of stretchable space.
The accidental does add a little non-stretchable space. 
"
}

%% not raggedright!!
\layout {
  linewidth = 18.\cm
}
\relative c'' \context GrandStaff {
  #(set-accidental-style 'piano-cautionary)
  \time 2/4 
  d16 d d d d d cis d dis dis dis dis 
  
}

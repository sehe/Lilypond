\header {

  texidoc = "By setting texts starting with a multi-measure rest, an 
extra spacing column is created. This should not cause problems."
}

  \layout {
    raggedright = ##t
  }

\version "2.7.13"


<<
  \set Score.skipBars = ##t
  \context Staff = "flute"  \new Voice { 
    <<  { R1*40 }  { s1*0_"bla" }>> 
  }
>>

 

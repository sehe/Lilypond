
\version "2.7.13"
\header {
    texidoc ="The a2 string is printed only on notes (i.e. not on rests),
and only after chords, solo or polyphony."
    }

vone =  \relative a' { R1*2 g2 r2 g2 r2 a4 r4 g }
vtwo =  \relative a' { R1*2 g2 r2 g2 r2 f4 r4 g }

comment = \relative { s1*2 s2_"a2" s2 s2_"no a2" s2 s4 s4 s4_"a2" } 

\layout { raggedright = ##T }

\new Staff << \set Score.skipBars = ##t 
   \partcombine \vone \vtwo
   \comment
>>
 

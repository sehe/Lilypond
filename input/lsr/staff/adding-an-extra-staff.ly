%%  Do not edit this file; it is auto-generated from LSR!
\version "2.10.12"

\header { texidoc = "
You can add (possibly temporarily) an extra staff after the beginning
of  a piece.  
" }

\score {
	<<
		\new Staff \relative c''{ c1 c c c c }
		\new StaffGroup \relative c''{ 
			\new Staff 
			c1 c
			<< c1 \new Staff { c1 } >>
			c
		}
	>>
  	\layout {
		
		\context{
			\Score

		}
	}
}





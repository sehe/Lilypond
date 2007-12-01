%%  Do not edit this file; it is auto-generated from LSR!
\version "2.10.12"

\header { texidoc = "
In order to change staff sizes, both @code{staff-space} and
@code{fontSize} must be scaled. 
" }

{
    \new Staff \relative c'' { \dynamicDown c8 \ff c c c c c c c } 
}

{
    \new Staff \with {
	fontSize = #-3
	\override StaffSymbol #'staff-space = #(magstep -3)
    } {
	\clef bass
	c8 c c c  c c c c
    }
}

%%  Do not edit this file; it is auto-generated from LSR!
\version "2.10.12"

\header { texidoc = "
The appearance of slurs may be changed from solid to dotted or dashed.


" }

\score{
	\relative c'{
		c( d e  c) |
		\slurDotted
		c( d e  c) |
		\slurSolid
		c( d e  c) |
		\slurDashed
		c( d e  c) |
		\slurSolid
		c( d e  c) |
	}
	\layout{ raggedright=##t }
}




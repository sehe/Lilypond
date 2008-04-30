%% Do not edit this file; it is auto-generated from LSR http://lsr.dsi.unimi.it
%% This file is in the public domain.
\version "2.11.38"

\header {
  lsrtags = "pitches, editorial-annotations"

  texidoc = "
The @code{shapeNoteStyles} property can be used to define various note
head styles for each step of the scale (as set by the key signature or
the \"tonic\" property). This property requires a set of symbols, which
can be purely arbitrary (geometrical expressions such as
@code{triangle}, @code{cross}, and @code{xcircle} are allowed) or based
on old American engraving tradition (some latin note names are also
allowed).

That said, to imitate old American song books, there are several
predefined note head styles available through shortcut commands such as
@code{\\aikenHeads} or @code{\\sacredHarpHeads}.

This example shows different ways to obtain shape note heads, and
demonstrates the ability to transpose a melody without losing the
correspondence between harmonic functions and note head styles. 

"
  doctitle = "Applying note head styles depending on the step of the scale"
} % begin verbatim
fragment = {
  \key c \major
  c2 d e f g a b c
}

\score {
  \new Staff {
    \transpose c d 
    \relative {
      \set shapeNoteStyles = ##(do re mi fa #f la ti)
      \fragment
    }
    
    \relative {
      \set shapeNoteStyles  = ##(cross triangle fa #f mensural xcircle diamond)
      \fragment
    }
  }
}

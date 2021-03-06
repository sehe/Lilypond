% DO NOT EDIT this file manually; it is automatically
% generated from Documentation/snippets/new
% Make any changes in Documentation/snippets/new/
% and then run scripts/auxiliar/makelsr.py
%
% This file is in the public domain.
%% Note: this file works from version 2.14.0
\version "2.14.0"

\header {
%% Translation of GIT committish: 6977ddc9a3b63ea810eaecb864269c7d847ccf98
  texidoces = "

Los deslizamientos se pueden componer tipográficamente tanto en los
contextos de @code{Staff} como en los de @code{TabStaff}:

"

  doctitlees = "Deslizamientos en tablatura"

%% Translation of GIT committish: f86f00c1a8de0f034ba48506de2801c074bd5422
  texidocde = "
Gleiten kann sowohl in normalem Notensystem als auch in Tabulaturen notiert werden:
"
  doctitlede = "Gleiten (Glissando) in Tabulatur"

%% Translation of GIT committish: 3b125956b08d27ef39cd48bfa3a2f1e1bb2ae8b4
  texidocfr = "
Un glissando s'indique dans un @code{TabStaff} tout comme dans un
@code{Staff}.

"
  doctitlefr = "Glissando et tablature"


  lsrtags = "fretted-strings"
  texidoc = "
Slides can be typeset in both @code{Staff} and @code{TabStaff} contexts:
"
  doctitle = "Slides in tablature"
} % begin verbatim


slides = {
  c'8\3(\glissando d'8\3)
  c'8\3\glissando d'8\3
  \hideNotes
  \grace { g16\3\glissando }
  \unHideNotes
  c'4\3
  \afterGrace d'4\3\glissando {
  \stemDown \hideNotes
  g16\3 }
  \unHideNotes
}

\score {
  <<
    \new Staff { \clef "treble_8" \slides }
    \new TabStaff { \slides }
  >>
  \layout {
    \context {
      \Score
      \override Glissando #'minimum-length = #4
      \override Glissando #'springs-and-rods =
                          #ly:spanner::set-spacing-rods
      \override Glissando #'thickness = #2
    }
  }
}

%% DO NOT EDIT this file manually; it is automatically
%% generated from LSR http://lsr.dsi.unimi.it
%% Make any changes in LSR itself, or in Documentation/snippets/new/ ,
%% and then run scripts/auxiliar/makelsr.py
%%
%% This file is in the public domain.
\version "2.14.0"

\header {
  lsrtags = "pitches, tweaks-and-overrides"

%% Translation of GIT committish: 6977ddc9a3b63ea810eaecb864269c7d847ccf98
  texidoces = "
Cuando se produce un cambio de clave, el símbolo de clave se imprime a
un tamaño menor que la clave inicial.  Esto se puede ajustar con
@code{full-size-change}.

"
  doctitlees = "Mantener el tamaño del símbolo en los cambios de clave"



  texidoc = "
When a clef is changed, the clef sign displayed is smaller than the
initial clef.  This can be overridden with @code{full-size-change}.

"
  doctitle = "Keep change clefs full sized"
} % begin verbatim

\relative c' {
  \clef "treble"
  c1
  \clef "bass"
  c1
  \clef "treble"
  c1
  \override Staff.Clef #'full-size-change = ##t
  \clef "bass"
  c1
  \clef "treble"
  c1
  \revert Staff.Clef #'full-size-change
  \clef "bass"
  c1
  \clef "treble"
  c1
}


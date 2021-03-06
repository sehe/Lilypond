%% DO NOT EDIT this file manually; it is automatically
%% generated from LSR http://lsr.dsi.unimi.it
%% Make any changes in LSR itself, or in Documentation/snippets/new/ ,
%% and then run scripts/auxiliar/makelsr.py
%%
%% This file is in the public domain.
\version "2.14.0"

\header {
  lsrtags = "expressive-marks"

%% Translation of GIT committish: 6977ddc9a3b63ea810eaecb864269c7d847ccf98
  texidoces = "
Algunos compositores escriben dos ligaduras cuando quieren acordes
legato.  Esto se puede conseguir estableciendo @code{doubleSlurs}.

"
  doctitlees = "Utilizar ligaduras dobles para acordes legato"


%% Translation of GIT committish: 0a868be38a775ecb1ef935b079000cebbc64de40
texidocde = "
Einige Komponisten schreiben doppelte Bögen, wenn Legato-Akkorde notiert
werden.  Das kann mit der Eigenschaft @code{doubleSlurs} erreicht werden.

"
  doctitlede = "Doppelte Bögen für Legato-Akkorde benutzen"

%% Translation of GIT committish: 3b125956b08d27ef39cd48bfa3a2f1e1bb2ae8b4
  texidocfr = "
Certains auteurs utilisent deux liaisons lorsqu'ils veulent
lier des accords.  Dans LilyPond, il faut pour cela activer
la propriété @code{doubleSlurs}.

"
  doctitlefr = "Accords et double liaison d'articulation"


  texidoc = "
Some composers write two slurs when they want legato chords.  This can
be achieved by setting @code{doubleSlurs}.

"
  doctitle = "Using double slurs for legato chords"
} % begin verbatim

\relative c' {
  \set doubleSlurs = ##t
  <c e>4( <d f> <c e> <d f>)
}


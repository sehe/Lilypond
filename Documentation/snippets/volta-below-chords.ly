%% DO NOT EDIT this file manually; it is automatically
%% generated from LSR http://lsr.dsi.unimi.it
%% Make any changes in LSR itself, or in Documentation/snippets/new/ ,
%% and then run scripts/auxiliar/makelsr.py
%%
%% This file is in the public domain.
\version "2.14.0"

\header {
  lsrtags = "repeats, staff-notation, chords"

%% Translation of GIT committish: 6977ddc9a3b63ea810eaecb864269c7d847ccf98
  texidoces = "
Mediante la adición del grabador @code{Volta_engraver} al
pentagrama pertinente, se pueden poner los corchetes de primera y
segunda vez debajo de los acordes.

"
  doctitlees = "Corchetes de primera y segunda vez debajo de los acordes"



%% Translation of GIT committish: 0a868be38a775ecb1ef935b079000cebbc64de40
  texidocde = "
Indem man den @code{Volta_engraver} zu dem entsprechenden Notensystem
hinzufügt, können Wiederholungsklammern unterhalb der Akkorde gesetzt
werden.

"
  doctitlede = "Wiederholungs-(Volta-)Klammern unterhalb der Akkordsymbole"

%% Translation of GIT committish: 3b125956b08d27ef39cd48bfa3a2f1e1bb2ae8b4
  texidocfr = "
L'ajout du @code{Volta_engraver} à la bonne portée permet d'imprimer les
crochets de reprise entre les chiffrages et la portée.

"
  doctitlefr = "Crochet de reprise sous les chiffrages d'accord"

  texidoc = "
By adding the @code{Volta_engraver} to the relevant staff, volte can be
put under chords.

"
  doctitle = "Volta below chords"
} % begin verbatim

\score {
  <<
    \chords {
      c1
      c1
    }
    \new Staff \with {
      \consists "Volta_engraver"
    }
    {
      \repeat volta 2 { c'1 }
      \alternative { c' }
    }
  >>
  \layout {
    \context {
      \Score
      \remove "Volta_engraver"
    }
  }
}

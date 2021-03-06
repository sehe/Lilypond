%% DO NOT EDIT this file manually; it is automatically
%% generated from LSR http://lsr.dsi.unimi.it
%% Make any changes in LSR itself, or in Documentation/snippets/new/ ,
%% and then run scripts/auxiliar/makelsr.py
%%
%% This file is in the public domain.
\version "2.15.25"

\header {
  lsrtags = "vocal-music, keyboards, template"

%% Translation of GIT committish: 6977ddc9a3b63ea810eaecb864269c7d847ccf98
  texidoces = "
He aquí el típico formato dde una canción: un pentagrama con la
melodía y la letra, y el acompañamiento de piano por debajo.

"
  doctitlees = "Plantilla de piano con melodía y letra"


%% Translation of GIT committish: fa1aa6efe68346f465cfdb9565ffe35083797b86
  texidocja = "
これは一般的な歌曲のフォーマットです: 旋律と歌詞を持つ譜表と、その下にピアノ伴奏譜があります。
"

%% Translation of GIT committish: c3b519f0dd5ff0f8ccfc9a39ed1fe8df8b43741c
  texidocit = "
Ecco un tipico formato per canzoni: un rigo con linea melodica e testo,
e sotto l'accompagnamento per pianoforte.

"
  doctitleit = "Modello per pianoforte con melodia e testo"

%% Translation of GIT committish: 0a868be38a775ecb1ef935b079000cebbc64de40
  texidocde = "
Das nächste Beispiel ist typisch für ein Lied: Im oberen System die
Melodie mit Text, darunter Klavierbegleitung.
"

  doctitlede = "Vorlage für Klavier und Gesangsstimme"


%% Translation of GIT committish: ceb0afe7d4d0bdb3d17b9d0bff7936bb2a424d16
  texidocfr = "
Il s'agit du format classique pour le chant : une portée pour la mélodie
et les paroles au-dessus de l'accompagnement au piano.

"
  doctitlefr = "Piano mélodie et paroles"

  texidoc = "
Here is a typical song format: one staff with the melody and lyrics,
with piano accompaniment underneath.

"
  doctitle = "Piano template with melody and lyrics"
} % begin verbatim

melody = \relative c'' {
  \clef treble
  \key c \major
  \time 4/4

  a b c d
}

text = \lyricmode {
  Aaa Bee Cee Dee
}

upper = \relative c'' {
  \clef treble
  \key c \major
  \time 4/4

  a4 b c d
}

lower = \relative c {
  \clef bass
  \key c \major
  \time 4/4

  a2 c
}

\score {
  <<
    \new Voice = "mel" { \autoBeamOff \melody }
    \new Lyrics \lyricsto mel \text
    \new PianoStaff <<
      \new Staff = "upper" \upper
      \new Staff = "lower" \lower
    >>
  >>
  \layout {
    \context { \Staff \RemoveEmptyStaves }
  }
  \midi { }
}


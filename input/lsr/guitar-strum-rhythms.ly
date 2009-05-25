%% Do not edit this file; it is auto-generated from input/new
%% This file is in the public domain.
%% Note: this file works from version 2.12.0
\version "2.13.1"

\header {
%% Translation of GIT committish: 70f455b078620f842672c64c66d87a08158a24ac
  texidoces = "
Para la música de guitarra, es posible mostrar los ritmos de rasgueo,
además de las notas de la melodía, acordes y diagramas de posiciones.

"
  doctitlees = "Ritmos rasgueados de guitarra"

%% Translation of GIT committish: 6ce7f350682dfa99af97929be1dec6b9f1cbc01a
  texidocde = "
In Guitarrennotation kann neben Melodie, Akkordbezeichnungen und
Bunddiagrammen auch der Schlagrhythmus angegeben werden.

"
  doctitlede = "Schlagrhythmus für Guitarren"


%% Translation of GIT committish: fa7695ea860d7ab2db86581dd5f8bc4f413f6705
  texidocfr = "
En matière de notation pour guitare, il arrive que soient indiqués les
@qq{coups de gratte} en plus de la mélodie, grilles d'accords et
diagrammes de tablature.

"
  doctitlede = "Rythmique et guitare"

  lsrtags = "rhythms,fretted-strings"
  texidoc = "
For guitar music, it is possible to show strum rhythms, along
with melody notes, chord names, and fret diagrams.
"
  doctitle = "Guitar strum rhythms"
} % begin verbatim


\include "predefined-guitar-fretboards.ly"
<<
  \new ChordNames {
    \chordmode {
      c1 f g c
    }
  }
  \new FretBoards {
    \chordmode {
      c1 f g c
    }
  }
  \new Voice \with {
    \consists "Pitch_squash_engraver"
  } {
    \relative c'' {
      \improvisationOn
      c4 c8 c c4 c8 c
      f4 f8 f f4 f8 f
      g4 g8 g g4 g8 g
      c4 c8 c c4 c8 c
    }
  }
  \new Voice = "melody" {
    \relative c'' {
      c2 e4 e4
      f2. r4
      g2. a4
      e4 c2.
    }
  }
  \new Lyrics {
    \lyricsto "melody" {
      This is my song.
      I like to sing.
    }
  }
>>

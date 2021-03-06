%% DO NOT EDIT this file manually; it is automatically
%% generated from LSR http://lsr.dsi.unimi.it
%% Make any changes in LSR itself, or in Documentation/snippets/new/ ,
%% and then run scripts/auxiliar/makelsr.py
%%
%% This file is in the public domain.
\version "2.14.0"

\header {
%% Translation of GIT committish: 5a7301fc350ffc3ab5bd3a2084c91666c9e9a549
  texidoces = "
Es posible usar el modo de marcado para dar formato a sílabas
individuales dentro de la letra.

"
  doctitlees = "Dar formato a sílabas de la letra"

  lsrtags = "text, vocal-music"

%%%    Translation of GIT committish: f86f00c1a8de0f034ba48506de2801c074bd5422
  texidocde = "
Textbeschriftungsmodus kann eingesetzt werden, um individuelle Silben im Gesangstext
zu formatieren.

"
  doctitlede = "Silben im Gesangstext formatieren"
%%  Translation of GIT committish: d9d1da30361a0bcaea1ae058eb1bc8dd3a5b2e4c
  texidocfr = "
Le mode markup permet d'individualiser la mise en forme de certaines syllabes.

"
  doctitlefr = "Mise en forme individuelle de syllabes"

  texidoc = "
Markup mode may be used to format individual syllables in lyrics.

"
  doctitle = "Formatting lyrics syllables"
} % begin verbatim

mel = \relative c'' { c4 c c c }
lyr = \lyricmode {
  Lyrics \markup { \italic can } \markup { \with-color #red contain }
  \markup { \fontsize #8 \bold Markup! }
}

<<
  \new Voice = melody \mel
  \new Lyrics \lyricsto melody \lyr
>>

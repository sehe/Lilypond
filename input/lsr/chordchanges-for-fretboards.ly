%% Do not edit this file; it is auto-generated from input/new
%% This file is in the public domain.
%% Note: this file works from version 2.13.0
\version "2.13.1"

\header {
%% Translation of GIT committish: 70f455b078620f842672c64c66d87a08158a24ac
  texidoces = "
Se puede hacer que los diagramas de posiciones se muestren sólo
cuando el acorde cambia o al comienzo de una nueva línea.

"

  doctitlees = "Cambios de acorde de posiciones de trastes"

%% Translation of GIT committish: 6bf3e9149eb97e66b4c813e41dc7625f06c501aa
texidocde = "
Bunddiagramme können definiert werden, sodass sie nur angezeigt werden,
wenn der Akkord sich ändert oder eine neue Zeile anfängt.

"


  doctitlede = "Akkordänderungen für Bunddiagramme"

  lsrtags = "fretted-strings"
  texidoc = "FretBoards can be set to display only when the chord changes
or at the beginning of a new line."
  doctitle = "chordChanges for FretBoards"
} % begin verbatim


\include "predefined-guitar-fretboards.ly"

myChords = \chordmode {
  c1 c1 \break
  \set chordChanges = ##t
  c1 c1 \break
  c1 c1 \break
}

<<
  \new ChordNames { \myChords }
  \new FretBoards { \myChords }
  \new Staff { \myChords }
>>

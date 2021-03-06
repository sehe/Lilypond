% DO NOT EDIT this file manually; it is automatically
% generated from Documentation/snippets/new
% Make any changes in Documentation/snippets/new/
% and then run scripts/auxiliar/makelsr.py
%
% This file is in the public domain.
%% Note: this file works from version 2.15.14
\version "2.15.14"

\header {
%% Translation of GIT committish: 6977ddc9a3b63ea810eaecb864269c7d847ccf98
 doctitlees = "Posicionar los silencios multicompás"
 texidoces = "
A diferencia de los silencios normales, no existe una instrucción
predefinida para modificar la posición predeterminada de un
símbolo de silencio multicompás sobre el pentagrama, adjuntándolo
a una nota, independientemente de cuál sea su forma.  Sin embargo,
en la música polifónica los silencios multicompás de las voces de
numeración par e impar están separados verticalmente.  La
colocación de los silencios multicompás se puede controlar como se
ve a continuación:

"

%% Translation of GIT committish: 0a868be38a775ecb1ef935b079000cebbc64de40
texidocde = "
Anders als bei normalen Pausen gibt es keinen direkten Befehl, um die
vertikale Position von Ganztaktpausen zu beeinflussen, indem man sie an
eine Tonhöhe anhängt.  In polyphoner Notation wird aber dennoch die
Position der Pausen von geraden und ungeraden Stimmen voneinander
unterschieden.  Die Position von Ganztaktpausen kann wie folgt verändert
werden:
 "
  doctitlede = "Positionierung von Ganztaktpausen"



%% Translation of GIT committish: 3b125956b08d27ef39cd48bfa3a2f1e1bb2ae8b4
  texidocfr = "
Si l'on peut positionner verticalement un silence simple en le
rattachant à une note, il n'en va pas de même pour un silence
multi-mesures.  Néanmoins, et uniquement dans le cadre de musique
polyphonique, les silences multi-mesures sont positionnés différemment
selon qu'ils appartiennent à une voix au numéro pair ou impair.  Le
positionnement des silences multi-mesures peut se contrôler ainsi@tie{}:

"
  doctitlefr = "Positionnement des silences multi-mesures"

  lsrtags = "rhythms, tweaks-and-overrides"

  texidoc = "
Unlike ordinary rests, there is no predefined command to change the
staff position of a multi-measure rest symbol of either form by
attaching it to a note.  However, in polyphonic music multi-measure
rests in odd-numbered and even-numbered voices are vertically
separated. The positioning of multi-measure rests can be controlled as
follows:

"
  doctitle = "Positioning multi-measure rests"
} % begin verbatim


\relative c'' {
  % Multi-measure rests by default are set under the fourth line
  R1
  % They can be moved using an override
  \override MultiMeasureRest #'staff-position = #-2
  R1
  \override MultiMeasureRest #'staff-position = #0
  R1
  \override MultiMeasureRest #'staff-position = #2
  R1
  \override MultiMeasureRest #'staff-position = #3
  R1
  \override MultiMeasureRest #'staff-position = #6
  R1
  \revert MultiMeasureRest #'staff-position
  \break

  % In two Voices, odd-numbered voices are under the top line
  << { R1 } \\ { a1 } >>
  % Even-numbered voices are under the bottom line
  << { a1 } \\ { R1 } >>
  % Multi-measure rests in both voices remain separate
  << { R1 } \\ { R1 } >>

  % Separating multi-measure rests in more than two voices
  % requires an override
  << { R1 } \\ { R1 } \\
     \once \override MultiMeasureRest #'staff-position = #0
     { R1 }
  >>

  % Using compressed bars in multiple voices requires another override
  % in all voices to avoid multiple instances being printed
  \compressFullBarRests
  <<
   \revert MultiMeasureRest #'staff-position
    { R1*3 }
    \\
   \revert MultiMeasureRest #'staff-position
    { R1*3 }
  >>
}

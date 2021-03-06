% DO NOT EDIT this file manually; it is automatically
% generated from Documentation/snippets/new
% Make any changes in Documentation/snippets/new/
% and then run scripts/auxiliar/makelsr.py
%
% This file is in the public domain.
%% Note: this file works from version 2.15.15
\version "2.15.15"

\header {
%% Translation of GIT committish: 6977ddc9a3b63ea810eaecb864269c7d847ccf98
  texidoces = "
Este tipo de notación se utiliza para el canto de los Salmos, en
que las estrofas no siempre tienen la misma longitud.

"
  doctitlees = "Notación de responsos o salmos"

%% Translation of GIT committish: ab9e3136d78bfaf15cc6d77ed1975d252c3fe506

  texidocde = "
Diese Form der Notation wird benutzt für die Notation von Psalmen, in denen
die Strophen nicht die gleiche Länge haben.

"
  doctitlede = "Psalmennotation"


%% Translation of GIT committish: c1d5bb448321d688185e0c6b798575d4c325ae80
  texidocfr = "
Ce style de notation permet d'indiquer la mélodie d'une psalmodie
lorsque les strophes sont de longueur inégale.

"
  doctitlefr = "Notation pour psalmodie"


  lsrtags = "rhythms, vocal-music, ancient-notation, contexts-and-engravers"

  texidoc = "
This form of notation is used for the chant of the Psalms, where verses
aren't always the same length.

"
  doctitle = "Chant or psalms notation"
} % begin verbatim


stemOn = { \revert Staff.Stem #'transparent \revert Staff.Flag #'transparent }
stemOff = { \override Staff.Stem #'transparent = ##t \override Staff.Flag #'transparent = ##t }

\score {
  \new Staff \with { \remove "Time_signature_engraver" }
  {
    \key g \minor
    \cadenzaOn
    \stemOff a'\breve bes'4 g'4
    \stemOn a'2 \bar "||"
    \stemOff a'\breve g'4 a'4
    \stemOn f'2 \bar "||"
    \stemOff a'\breve^\markup { \italic flexe }
    \stemOn g'2 \bar "||"
  }
}


%% DO NOT EDIT this file manually; it is automatically
%% generated from LSR http://lsr.dsi.unimi.it
%% Make any changes in LSR itself, or in Documentation/snippets/new/ ,
%% and then run scripts/auxiliar/makelsr.py
%%
%% This file is in the public domain.
\version "2.14.0"

\header {
  lsrtags = "text, titles"

%% Translation of GIT committish: 6977ddc9a3b63ea810eaecb864269c7d847ccf98
  texidoces = "
Con algo de código de Scheme, se puede añadir fácilmente la fecha
actual a una partitura.
"
  doctitlees = "Añadir la fecha actual a una partitura"


%% Translation of GIT committish: 3b125956b08d27ef39cd48bfa3a2f1e1bb2ae8b4
  texidocfr = "
Avec un peu de code Scheme, voici comment ajouter facilement
la date du jour à votre partition.
"
  doctitlefr = "Ajout de la date du jour à une partition"

  texidoc = "
With a little Scheme code, the current date can easily be added to a
score.

"
  doctitle = "Adding the current date to a score"
} % begin verbatim

% first, define a variable to hold the formatted date:
date = #(strftime "%d-%m-%Y" (localtime (current-time)))

% use it in the title block:
\header {
  title = "Including the date!"
  subtitle = \date
}

\score {
  \relative c'' {
    c4 c c c
  }
}
% and use it in a \markup block:
\markup {
  \date
}


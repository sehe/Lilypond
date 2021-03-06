% DO NOT EDIT this file manually; it is automatically
% generated from Documentation/snippets/new
% Make any changes in Documentation/snippets/new/
% and then run scripts/auxiliar/makelsr.py
%
% This file is in the public domain.
%% Note: this file works from version 2.14.0
\version "2.14.0"

\header {
%%%    Translation of GIT committish: 6977ddc9a3b63ea810eaecb864269c7d847ccf98

  texidoces = "
En muchos casos, las llaves que no están en la columna central se
pueden presentar por el nombre de la llave así como de forma gráfica.

"

  doctitlees = "Diagramas para viento madera gráficos y textuales"

%%%    Translation of GIT committish: ab9e3136d78bfaf15cc6d77ed1975d252c3fe506


  texidocde="
In vielen Fällen können die nicht in der mittleren Reihe befindlichen
Löcher dargestellt werden, indem man die Lochbezeichnung oder
graphische Zeichen benutzt.

"

  doctitlede = "Graphische und Text-Holzbläserdiagramme"


%% Translation of GIT committish: 496c48f1f2e4d345ae3637b2c38ec748a55cda1d
  texidocfr = "
Dans certains cas, vous pouvez opter pour l'affichage textuel d'une clé
située à côté d'un trou plutôt que sa représentation graphique.
"

  doctitlefr = "Ajout de texte à un diagramme de doigté"


  lsrtags="winds"
  texidoc="
In may cases, the keys other than the central column can be
displayed by key name as well as by graphical means.
"

  doctitle = "Graphical and text woodwind diagrams"
} % begin verbatim


\relative c'' {
  \textLengthOn
  c1^\markup
    \woodwind-diagram
      #'piccolo
      #'((cc . (one three))
         (lh . (gis))
         (rh . (ees)))

  c^\markup
    \override #'(graphical . #f) {
      \woodwind-diagram
        #'piccolo
        #'((cc . (one three))
           (lh . (gis))
           (rh . (ees)))
    }
}

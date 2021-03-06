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
Se pueden imprimir reguladores con un círculo en la punta (notación
«al niente») estableciendo la propiedad @code{circled-tip} del objeto
@code{Hairpin} al valor @code{#t}.

"
  doctitlees = "Impresión de reguladores utilizando la notación «al niente»"


%% Translation of GIT committish: 0a868be38a775ecb1ef935b079000cebbc64de40
 texidocde = "
 Crescendo-Klammern können mit einem kleinen Kreis vor der Spitze
 notiert werden (al niente = bis zum Nichts), indem die
@code{circled-tip}-Eigenschaft des @code{Hairpin}-Objekts auf
@code{#t} gesetzt wird.

"
  doctitlede = "Crescendo Klammern al niente schreiben"

%% Translation of GIT committish: 217cd2b9de6e783f2a5c8a42be9c70a82195ad20
  texidocfr = "
Des crescendos ou decrescendos @emph{al niente} peuvent être indiqués de
manière graphique, en assignant @emph{vrai} (@code{#t}) à la
propriété @code{circled-tip}, ce qui affiche un cercle à leur extrémité.

"
  doctitlefr = "Impression de soufflets « al niente »"


  texidoc = "
Hairpin dynamics may be printed with a circled tip (@qq{al niente}
notation) by setting the @code{circled-tip} property of the
@code{Hairpin} object to @code{#t}.

"
  doctitle = "Printing hairpins using al niente notation"
} % begin verbatim

\relative c'' {
  \override Hairpin #'circled-tip = ##t
  c2\< c\!
  c4\> c\< c2\!
}


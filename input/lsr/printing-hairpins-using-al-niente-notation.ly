%% Do not edit this file; it is auto-generated from LSR http://lsr.dsi.unimi.it
%% This file is in the public domain.
\version "2.11.62"

\header {
  lsrtags = "expressive-marks"

  texidoces = "
Se pueden imprimir reguladores con un círculo en la punta
(notación «al niente») estableciendo la propiedad
@code{circled-tip} del objeto @code{Hairpin} al valor @code{#t}.

"
  doctitlees = "Impresión de reguladores utilizando la notación «al niente»"
  
%% Translation of GIT committish :<6ce7f350682dfa99af97929be1dec6b9f1cbc01a>
 texidocde = "
 Crescendo-Klammern können mit einem kleinen Kreis vor der Spitze
 notiert werden (al niente = bis zum Nichts), indem die
@code{circled-tip}-Eigenschaft des @code{Hairpin}-Objekts auf
@code{#t} gesetzt wird.

"
  doctitlede = "Crescendo Klammern al niente schreiben"

  texidoc = "
Hairpins may be printed with a circled tip (al niente notation) by
setting the @code{circled-tip} property of the @code{Hairpin} object to
@code{#t}. 

"
  doctitle = "Printing hairpins using al niente notation"
} % begin verbatim

\relative c'' {
  \override Hairpin #'circled-tip = ##t
  c2\< c\!
  c4\> c\< c2\!
}

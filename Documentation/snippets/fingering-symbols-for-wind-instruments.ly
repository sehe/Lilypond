%% DO NOT EDIT this file manually; it is automatically
%% generated from LSR http://lsr.dsi.unimi.it
%% Make any changes in LSR itself, or in Documentation/snippets/new/ ,
%% and then run scripts/auxiliar/makelsr.py
%%
%% This file is in the public domain.
\version "2.14.0"

\header {
  lsrtags = "winds"

%% Translation of GIT committish: 6977ddc9a3b63ea810eaecb864269c7d847ccf98
  texidoces = "
Se pueden conseguir símbolos especiales combinando glifos existentes,
lo que es de utilidad para la notación de instrumentos de viento.

"
  doctitlees = "Símbolos de digitación para instrumentos de viento"

%% Translation of GIT committish: 3b125956b08d27ef39cd48bfa3a2f1e1bb2ae8b4
  texidocfr = "
Des symboles spécifiques peuvent être obtenus en combinant les glyphes
disponibles, ce qui est tout à fait indiqué en matière d'instrument à vent.

"
  doctitlefr = "Symboles de doigtés pour instruments à vent"


  texidoc = "
Special symbols can be achieved by combining existing glyphs, which is
useful for wind instruments.

"
  doctitle = "Fingering symbols for wind instruments"
} % begin verbatim

centermarkup = {
  \once \override TextScript #'self-alignment-X = #CENTER
  \once \override TextScript #'X-offset =#(ly:make-simple-closure
    `(,+
      ,(ly:make-simple-closure (list
        ly:self-alignment-interface::centered-on-x-parent))
      ,(ly:make-simple-closure (list
        ly:self-alignment-interface::x-aligned-on-self))))
}
\score
{\relative c'
  {
    g\open
    \once \override TextScript #'staff-padding = #-1.0 \centermarkup
    g^\markup{\combine \musicglyph #"scripts.open" \musicglyph
    #"scripts.tenuto"}
    \centermarkup g^\markup{\combine \musicglyph #"scripts.open"
    \musicglyph #"scripts.stopped"}
    g\stopped
  }
}


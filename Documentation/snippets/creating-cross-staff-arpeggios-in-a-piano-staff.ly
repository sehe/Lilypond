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
Dentro de un @code{PianoStaff}, es posible hacer que un arpegio
cruce entre los pentagramas ajustando la propiedad
@code{PianoStaff.connectArpeggios}.

"
  doctitlees = "Crear arpegios que se cruzan entre pentagramas dentro de un sistema de piano"


%% Translation of GIT committish: 0a868be38a775ecb1ef935b079000cebbc64de40
texidocde = "
Arpeggio über mehrere Systeme können in anderen Kontexten als dem
@code{PianoStaff} erstellt werden, wenn der @code{Span_arpeggio_engraver}
in den @code{Score}-Kontext eingefügt wird.

"
  doctitlede = "Arpeggio über mehrere Systeme in anderen Kontexten"

%% Translation of GIT committish: 4ab2514496ac3d88a9f3121a76f890c97cedcf4e
  texidocfr = "
Dans une double portée pour piano (@code{PianoStaff}), un arpège peut
s'étendre sur les deux portées grâce à la propriété
@code{PianoStaff.connectArpeggios}.

"
  doctitlefr = "Arpège distribué sur une partition pour piano"


  texidoc = "
In a @code{PianoStaff}, it is possible to let an arpeggio cross between
the staves by setting the property @code{PianoStaff.connectArpeggios}.


"
  doctitle = "Creating cross-staff arpeggios in a piano staff"
} % begin verbatim

\new PianoStaff \relative c'' <<
  \set PianoStaff.connectArpeggios = ##t
  \new Staff {
    <c e g c>4\arpeggio
    <g c e g>4\arpeggio
    <e g c e>4\arpeggio
    <c e g c>4\arpeggio
  }
  \new Staff {
    \clef bass
    \repeat unfold 4 {
      <c,, e g c>4\arpeggio
    }
  }
>>


\version "2.14.0"

\header {
  lsrtags = "fretted-strings"

  texidoc = "
For flamenco guitar, special notation is used:


@itemize

@item
a golpe symbol to indicate a slap on the guitar body with the nail of
the ring finger

@item
an arrow to indicate (the direction of) strokes

@item
different letters for fingering (@qq{p}: thumb, @qq{i}: index finger,
@qq{m}: middle finger, @qq{a}: ring finger and @qq{x}: little finger)

@item
3- and 4-finger rasgueados: stroke upwards with all fingers, ending
with an up- and down using the index finger

@item
abanicos: strokes (in tuples) with thumb (down), little and index finger
(both up) (there is also an abanico 2 where middle and ring finger are
used instead of the little finger)

@item
alza pua: fast playing with the thumb

@end itemize


Most figures use arrows in combination with fingering; with abanicos
and rasgueados, noteheads are printed only for the first chord.

This snippet contains some header-like code that can be copied as
@samp{flamenco.ly} and included in source files.

"
  doctitle = "Flamenco notation"
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%  Cut here ----- Start 'flamenco.ly'

% Text indicators
abanico = \markup { \italic Abanico }
rasgueaso = \markup { \italic Ras. }
alzapua = \markup { \italic Alzapua }

% Finger stroke symbols
strokeUp = \markup { \postscript #"
  0.1     setlinewidth
  0.5 0   moveto
  0.5 2   lineto
  0.2 1.4 lineto
  0.5 2   moveto
  0.8 1.4 lineto
  stroke
"}

strokeDown = \markup { \postscript #"
  0.1     setlinewidth
  0.5 2   moveto
  0.5 0   lineto
  0.2 0.6 lineto
  0.5 0   moveto
  0.8 0.6 lineto
  stroke
"}

% Golpe symbol
golpe = \markup { \postscript #"
  0.2 setlinewidth
  0 0 moveto
  1 0 lineto
  1 1 lineto
  stroke
  "\postscript #"
  0.1       setlinewidth
  -0.6 -0.1  moveto
  -0.6  1.0 lineto
  0.5  1.0 lineto
  stroke
"}

strokeUpGolpe = \markup { \column { \golpe \line { \strokeUp } } }
iUpGolpe = \markup { \column { \golpe \line { \small i } \line { \strokeUp } } }

% Strokes for all fingers
pUp   = \markup { \column { \small p \line { \strokeUp } } }
pDown = \markup { \column { \small p \line { \strokeDown } } }
iUp   = \markup { \column { \small i \line { \strokeUp } } }
iDown = \markup { \column { \small i \line { \strokeDown } } }
mUp   = \markup { \column { \small m \line { \strokeUp } } }
mDown = \markup { \column { \small m \line { \strokeDown } } }
aUp   = \markup { \column { \small a \line { \strokeUp } } }
aDown = \markup { \column { \small a \line { \strokeDown } } }
xUp   = \markup { \column { \small x \line { \strokeUp } } }
xDown = \markup { \column { \small x \line { \strokeDown } } }


% Just handy :)
tupletOff = {
  \once \override TupletNumber #'stencil = ##f
  \once \override TupletBracket #'stencil = ##f
}

tupletsOff = {
  \override TupletNumber #'stencil = ##f
  \override TupletBracket #'bracket-visibility = #'if-no-beam
}

tupletsOn = {
  \override TupletBracket #'bracket-visibility = #'default
  \revert TupletNumber #'stencil
}

headsOff = {
  \override TabNoteHead #'transparent = ##t
  \override NoteHead #'transparent = ##t
  \override NoteHead #'no-ledgers = ##t
}

headsOn = {
  \override TabNoteHead #'transparent = ##f
  \override NoteHead #'transparent = ##f
  \override NoteHead #'no-ledgers = ##f
}

%%%%%%%  Cut here ----- End 'flamenco.ly'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

part = \relative c' {
  <a, e' a cis e>8^\iUp
  <a e' a cis e>8^\iDown
  r4
  r2^\golpe

  <a e' a cis e>8^\iUp
  <a e' a cis e>8^\iDown
  <a e' a cis e>8^\iUpGolpe
  <a e' a cis e>8^\iDown
  r2

  <a e' a cis e>16^\aUp
  \headsOff
  <a e' a cis e>^\mUp
  <a e' a cis e>^\iUp
  <a e' a cis e>^\iDown~
  \headsOn
  <a e' a cis e>2
  r4

  \tupletOff
  \times 4/5 {
    <a e' a cis e>16^\xUp
    \headsOff
    <a e' a cis e>^\aUp
    <a e' a cis e>^\mUp
    <a e' a cis e>^\iUp
    <a e' a cis e>^\iDown~
    \headsOn
  }
  <a e' a cis e>2
  r4

  \tupletsOff
  \times 2/3 {
    <a e' a cis e>8^\pDown
    \headsOff
    <a e' a cis e>^\xUp
    <a e' a cis e>^\iUp
    \headsOn
  }

  \times 2/3 {
    <a e' a cis e>8^\pDown
    \headsOff
    <a e' a cis e>^\xUp
    <a e' a cis e>^\iUp
    \headsOn
  }

  \times 2/3 {
    <a e' a cis e>8^\pDown
    \headsOff
    <a e' a cis e>^\xUp
    <a e' a cis e>^\iUp
    \headsOn
  }
  \times 2/3 {
    <a e' a cis e>8^\pDown
    \headsOff
    <a e' a cis e>^\xUp
    <a e' a cis e>^\iUp
    \headsOn
  }

  \tupletsOff
  \override Beam #'positions = #'(2 . 2)
  \times 2/3 {
    a8^\markup{ \small p }
    <e' a>^\strokeUpGolpe
    <e a>^\strokeDown
  }
  \times 2/3 {
    a,8^\markup{ \small p }
    <e' a>^\strokeUpGolpe
    <e a>^\strokeDown
  }
  \times 2/3 {
    a,8^\markup{ \small p }
    <e' a>^\strokeUpGolpe
    <e a>^\strokeDown
  }
  \times 2/3 {
    a,8^\markup{ \small p }
    <e' a>^\strokeUpGolpe
    <e a>^\strokeDown
  }
  \tupletsOn

  \once \override TextScript #'extra-offset = #'(0 . -1)
  <g, b f'>1_\golpe^\mUp
  \bar "|."
}

\score {
  \new StaffGroup <<
    \context Staff = "part" <<
      \clef G
      \transpose c c'
      {
        \part
      }
    >>
    \context TabStaff {
      \part
    }
  >>
  \layout {
    ragged-right = ##t
  }
}

%% Do not edit this file; it is auto-generated from LSR http://lsr.dsi.unimi.it
%% This file is in the public domain.
\version "2.11.49"

\header {
  lsrtags = "contexts-and-engravers, midi"

  texidoc = "
When outputting MIDI, the default behavior is for each staff to
represent one MIDI channel, with all the voices on a staff amalgamated.
This minimizes the risk of running out of MIDI channels, since there
are only 16 available per track.

However, by moving the @code{Staff_performer} to the @code{Voice}
context, each voice on a staff can have its own MIDI channel, as is
demonstrated by the following example: despite being on the same staff,
two MIDI channels are created, each with a different
@code{midiInstrument}. 

"
  doctitle = "Changing MIDI output to one channel per voice"
} % begin verbatim
\score {
  \new Staff <<
    \new Voice \relative c''' {
      \set midiInstrument = #"flute"
      \voiceOne
      \key g \major
      \time 2/2
      r2 g-"Flute" ~
      g fis ~
      fis4 g8 fis e2 ~
      e4 d8 cis d2
    }
    \new Voice \relative c'' {
      \set midiInstrument = #"clarinet"
      \voiceTwo
      b1-"Clarinet"
      a2. b8 a
      g2. fis8 e
      fis2 r
    }
  >>
  \layout { }
  \midi {
    \context {
      \Staff
      \remove "Staff_performer"
    }
    \context {
      \Voice
      \consists "Staff_performer"      
    }
    \context {
      \Score
      tempoWholesPerMinute = #(ly:make-moment 72 2)
    }
  }
}
\version "2.15.25"
\header {
  texidoc = "Footnotes are annotated at the correct place, and the
annotation goes to the correct page."
}

#(set-default-paper-size "a6")

\paper {
  ragged-last-bottom = ##f
}

\book {

\relative c'' {
\footnote
              \markup { \tiny "1." }
              #'(0.5 . 0.5) #'Hairpin
              \markup { 1. \justify { Goes to the first broken spanner. } }
b4\< c d a
b c d a
b c d a
b c d a
b c d a
b c d a \break \pageBreak
b c d a
b c d a
b c d a
b c d a
b c d a
b c d a
b c d a
b c d a
b c d a
b c d a
b c d a
b c d a\!

\once \override FootnoteSpanner #'spanner-placement = #RIGHT
\footnote
              \markup { \tiny "2." }
              #'(0.5 . 0.5) #'Hairpin
              \markup { 2. \justify { Goes to the last broken spanner. } }
b4\< c d a
b c d a
b c d a
b c d a
b c d a
b c d a \break \pageBreak
b c d a
b c d a
b c d a
b c d a
b c d a
b c d a
b c d a
b c d a
b c d a
b c d a
b c d a
b c d\!
}}

%% DO NOT EDIT this file manually; it is automatically
%% generated from LSR http://lsr.dsi.unimi.it
%% Make any changes in LSR itself, or in Documentation/snippets/new/ ,
%% and then run scripts/auxiliar/makelsr.py
%%
%% This file is in the public domain.
\version "2.14.0"

\header {
  lsrtags = "expressive-marks, staff-notation, editorial-annotations, tweaks-and-overrides"

  texidoc = "
By default you cannot make double-digit fingering notation (i.e.
numbers larger than 9). This is a hard coded limitation.

This snippet shows two methods of creating fingerings larger than 9.

"
  doctitle = "Creating double-digit fingerings"
} % begin verbatim

ten =
#(make-music 'FingeringEvent
             'digit 10)

fifty =
#(make-music 'FingeringEvent
             'digit 50)

finger =
#(define-music-function (parser location digit) (integer?)
   (make-music 'FingeringEvent
               'digit digit))

#(define (calc-finger-without-warning grob)
   (let* ((event (event-cause grob))
	  (digit (ly:event-property event 'digit)))
     (number->string digit 10)))

\relative c' {
  % optional override to remove warnings for fingerings larger than 5
  \override Fingering #'text = #calc-finger-without-warning
  c1\ten
  c1\fifty
  c1-\finger #36
  c1-\finger #29
}
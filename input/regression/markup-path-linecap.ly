\version "2.14.0"

\header {
  texidoc = "
The @code{\\path} markup command supports the
@code{line-cap-style} property with values of @code{butt},
@code{round}, and @code{square}.
"
}

myPath =
#'((moveto 0 0) (lineto 5 0))

\markup {
  \column {
    \override #'(line-cap-style . butt) {
      \path #1 #myPath
    }
    \override #'(line-cap-style . round) {
      \path #1 #myPath
    }
    \override #'(line-cap-style . square) {
      \path #1 #myPath
    }
  }
}

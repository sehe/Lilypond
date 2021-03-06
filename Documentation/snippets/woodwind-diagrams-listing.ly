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
El fragmento de música que aparece a continuación presenta todos los
diagramas de viento madera que se encuentran definidos en LilyPond por
el momento.

"
  doctitlees = "Listado de los diagramas para viento madera"

%%%    Translation of GIT committish: ab9e3136d78bfaf15cc6d77ed1975d252c3fe506


  texidocde="
Folgende Noten zeige alle Holzbläserdiagramme, die für LilyPond
definiert sind.

"
  doctitlede = "Liste der Holzbläserdiagramme"


%% Translation of GIT committish: 496c48f1f2e4d345ae3637b2c38ec748a55cda1d
  texidocfr = "
Voici la liste des différents instruments à vent de la section des bois
dont les doigtés sont disponibles à ce jour.
"
  doctitlefr = "Liste des diagrammes de doigtés pour bois"


  lsrtags="winds"
  texidoc="
The following music shows all of the woodwind diagrams currently
defined in LilyPond.
"
  doctitle = "Woodwind diagrams listing"

} % begin verbatim


\relative c' {
  \textLengthOn
  c1^
  \markup {
    \center-column {
      'piccolo
      " "
       \woodwind-diagram
                  #'piccolo
                  #'()
    }
  }

  c1^
  \markup {
    \center-column {
       'flute
       " "
       \woodwind-diagram
          #'flute
          #'()
    }
  }
  c1^\markup {
    \center-column {
      'oboe
      " "
      \woodwind-diagram
        #'oboe
        #'()
    }
  }

  c1^\markup {
    \center-column {
      'clarinet
      " "
      \woodwind-diagram
        #'clarinet
        #'()
    }
  }

  c1^\markup {
    \center-column {
      'bass-clarinet
      " "
      \woodwind-diagram
        #'bass-clarinet
        #'()
    }
  }

  c1^\markup {
    \center-column {
      'saxophone
      " "
      \woodwind-diagram
        #'saxophone
        #'()
    }
  }

  c1^\markup {
    \center-column {
      'bassoon
      " "
      \woodwind-diagram
        #'bassoon
        #'()
    }
  }

  c1^\markup {
    \center-column {
      'contrabassoon
      " "
      \woodwind-diagram
        #'contrabassoon
        #'()
    }
  }
}

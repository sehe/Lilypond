%% Do not edit this file; it is auto-generated from LSR http://lsr.dsi.unimi.it
%% This file is in the public domain.
\version "2.12.0"

\header {
  lsrtags = "rhythms, editorial-annotations, chords, tweaks-and-overrides"

  texidoces = "
Las digitaciones y los números de cuerda aplicados a notas
individuales evitan a las barras automáticamente, pero de forma
predeterminada esto no es cierto para las digitaciones y números
de cuerda que se aplican a notas concretas de acordes.  El ejemplo
siguiente muestra cómo se puede sobreescribir este comportamiento
predeterminado:

"
  doctitlees = "Evitar colisiones entre digitaciones de acordes y barras de corchea"

  texidoc = "
Fingerings and string numbers applied to individual notes will
automatically avoid beams, but this is not true by default for
fingerings and string numbers applied to the individual notes of
chords.  The following example shows how this default behavior can be
overridden:   

"
  doctitle = "Avoiding collisions of chord fingering with beams"
  texidocfr = "
Les doigtés et les numéros de cordes attachés à des notes seules
évitent automatiquement les barres de ligature, mais ce n'est pas le
cas par défaut pour les doigtés ou numéros de cordes attachés aux
notes d'un accord. L'exemple qui suit montre comment ce comportement
par défaut peut être corrigé.
"
  doctitlefr = "Éviter les collisions entre les doigtés d'accords et les ligatures"
} % begin verbatim

\relative c' {
  \set fingeringOrientations = #'(up)
  \set stringNumberOrientations = #'(up)
  \set strokeFingerOrientations = #'(up)
  
  % Default behavior
  r8
  <f c'-5>8
  <f c'\5>8
  <f c'-\rightHandFinger #2 >8
  
  % Corrected to avoid collisions
  r8
  \override Fingering #'add-stem-support = ##t
  <f c'-5>8
  \override StringNumber #'add-stem-support = ##t
  <f c'\5>8
  \override StrokeFinger #'add-stem-support = ##t
  <f c'-\rightHandFinger #2 >8
}

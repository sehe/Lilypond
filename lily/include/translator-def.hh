/*   
  translator-def.hh -- declare Translator_def
  
  source file of the GNU LilyPond music typesetter
  
  (c)  2000--2003 Han-Wen Nienhuys <hanwen@cs.uu.nl>
  
 */

#ifndef TRANSLATOR_DEF_HH
#define TRANSLATOR_DEF_HH

#include "lily-proto.hh"
#include "smobs.hh"
#include "input.hh"

/*
  The definition of a interpretation context as given in the
  input. The lists are stored in order of definition.
*/
struct Translator_def : public Input
{
private:
  /*
    these lists store the definition, in opposite order of entry
  */
  SCM translator_mods_;
  SCM accept_mods_;
  SCM property_ops_;

  SCM description_;
  SCM context_name_;
  SCM context_aliases_;
  SCM translator_group_type_;
  
public:
  void add_context_mod (SCM);
  SCM default_child_context_name ();
  SCM get_context_name () const;
  SCM get_accepted ()  const;
  SCM get_property_ops ()  const { return property_ops_; }
  SCM get_translator_names (SCM) const;
  void set_acceptor (SCM accepts, bool add);

  Link_array<Translator_def> path_to_acceptable_translator (SCM type_string, Music_output_def* odef) const;
  Translator_group * instantiate (Music_output_def*, SCM extra_ops);

  SCM to_alist () const;
  bool is_alias (SCM) const;
  static SCM make_scm () ;

  SCM clone_scm ()const;
  void apply_default_property_operations (Translator_group*);
private:
  DECLARE_SMOBS (Translator_def,foo);
  Translator_def ();
  Translator_def (Translator_def const&);
};

DECLARE_UNSMOB(Translator_def,translator_def);


#endif /* TRANSLATOR_DEF_HH */


/*
  staff-margin-engraver.cc -- implement Staff_margin_engraver

  source file of the GNU LilyPond music typesetter

  (c) 1998--1999 Jan Nieuwenhuizen <janneke@gnu.org>
*/

#include "staff-margin-engraver.hh"
#include "bar.hh"
#include "time-description.hh"
#include "text-item.hh"
#include "staff-side.hh"

ADD_THIS_TRANSLATOR (Staff_margin_engraver);

Staff_margin_engraver::Staff_margin_engraver ()
{
  axis_ = X_AXIS;
  type_ = "margin";
  visibility_lambda_ = ly_ch_C_eval_scm ("postbreak_only_visibility");
}


/*
    TODO

    should be able to set whole paragraph (multiple lines, center) to
    left (right?) of staff, e.g.:
                    ______
                   |_______
      2 Clarinetti |________
         (Bb)      |___________
	           |______________
*/
void
Staff_margin_engraver::acknowledge_element (Score_element_info inf)
{
  Item *i = cast_to_interesting_item (inf.elem_l_);
  if (!i || inf.origin_trans_l_arr_.size() != 1)
    return;


  SCM long_name = get_property ("instrument", 0);
  SCM short_name = get_property ("instr", 0);

  if (now_mom () > Moment (0))
    long_name = short_name;

  if (gh_string_p (long_name))
    {
      create_items (0);
      text_p_->text_str_ = ly_scm2string (long_name);
      staff_side_p_->dir_ = LEFT;
      Bar_script_engraver::attach_script_to_item (i);

      /*
    UGH. ignores font size settings.
   */
      Interval iv(text_p_->extent (Y_AXIS));
      text_p_->translate_axis (- iv.center (),  Y_AXIS);
    }
}


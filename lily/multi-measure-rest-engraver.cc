/*
  multi_measure_rest-engraver.cc -- implement Multi_measure_rest_engraver

  (c) 1998 Jan Nieuwenhuizen <janneke@gnu.org>
       Han-Wen Nienhuys <hanwen@cs.uu.nl>
*/

#include "proto.hh"
#include "musical-request.hh"
#include "multi-measure-rest.hh"
#include "multi-measure-rest-engraver.hh"
#include "score-column.hh"
#include "time-description.hh"
#include "p-score.hh"


ADD_THIS_TRANSLATOR (Multi_measure_rest_engraver);

Multi_measure_rest_engraver::Multi_measure_rest_engraver ()
{
  start_measure_i_ = 0;
  rest_item_creation_mom_ = rest_req_stop_mom_ =0;
  multi_measure_req_l_ = 0;
  mmrest_p_ = 0;
}

bool
Multi_measure_rest_engraver::do_try_music (Music* req_l)
{
 if (Multi_measure_rest_req *mr = dynamic_cast<Multi_measure_rest_req *> (req_l))
   {
     if (multi_measure_req_l_)
       if (!multi_measure_req_l_->equal_b (mr)
	   || req_start_mom_ != now_moment ())
	 return false;
  
     multi_measure_req_l_ = mr;
     req_start_mom_ = now_moment ();
     
     rest_req_stop_mom_ = req_start_mom_ + multi_measure_req_l_->duration_.length ();
     return true;
   }
 return false;
}

void
Multi_measure_rest_engraver::do_process_requests ()
{
  if (multi_measure_req_l_ && !mmrest_p_)
    {
      Time_description const *time = get_staff_info().time_C_;
      mmrest_p_ = new Multi_measure_rest;
      rest_item_creation_mom_ = time->when_mom ();

      rest_item_creation_mom_ += time->whole_per_measure_ / Moment (2);
#if 0
      // core dump because of missing column?
      mmrest_p_->pscore_l_->add_column (new Score_column (rest_item_creation_mom_));
      mmrest_p_->pscore_l_->add_column (new Score_column (rest_item_creation_mom_, true));
#endif

      announce_element (Score_element_info (mmrest_p_, multi_measure_req_l_));
      start_measure_i_ = time->bars_i_;
    }
}

void
Multi_measure_rest_engraver::do_pre_move_processing ()
{
  Moment now (now_moment ());
  if (mmrest_p_ && rest_item_creation_mom_ == now)
    {
      typeset_element (mmrest_p_);
    }
}

void
Multi_measure_rest_engraver::do_post_move_processing ()
{
  Time_description const *time = get_staff_info().time_C_;
  Moment now (now_moment ());
  if (rest_req_stop_mom_ <= now)
    multi_measure_req_l_ = 0;

  if (mmrest_p_ && (!time->whole_in_measure_ || !multi_measure_req_l_))
    {
      assert (rest_item_creation_mom_ < now);
      mmrest_p_ = 0;
    }
}

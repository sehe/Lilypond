//
// my-midi-parser.hh -- declare My_midi_parser
//
// copyright 1997 Jan Nieuwenhuizen <jan@digicash.com>

#ifndef MY_MIDI_PARSER_HH
#define MY_MIDI_PARSER_HH

#include "proto.hh"
#include "varray.hh"
#include "string.hh"

int yyparse();

/// (midi_parser)
class My_midi_parser {
public:
	My_midi_parser( String filename_str );
	~My_midi_parser();
	void add_score( Midi_score* midi_score_p );
	void error( char const* sz_l );
	int parse();
	void forward( Real f );
	void note_begin( int channel_i, int pitch_i, int dyn_i );
	Midi_event* note_end_midi_event_p( int channel_i, int pitch_i, int dyn_i );
	int output( String filename_str );
	void set_division( int clocks_per_4_i );
	void set_key( int accidentals_i, int minor_i );
	void set_tempo( int useconds_i );
	void set_time( int num_i, int den_i, int clocks_i, int count_32_i );

private:
	Real now_f_;
	Real step_f_;

	static int const CHANNELS_i = 16;
	static int const PITCHES_i = 128;
	Real running_f_f_a_[ CHANNELS_i ][ PITCHES_i ];

	Array<Midi_score*> midi_score_p_array_;
	int clocks_per_whole_i_;
	Midi_key* midi_key_p_;
	Midi_tempo* midi_tempo_p_;
	Midi_time* midi_time_p_;

	char const* defined_ch_c_l_;
	int fatal_error_i_;
	My_midi_lexer* midi_lexer_p_;
};

extern My_midi_parser* midi_parser_l_g;

#endif // MY_MIDI_PARSER_HH


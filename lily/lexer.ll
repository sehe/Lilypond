%{ // -*- mode: c++; c-file-style: "linux" -*-
/*
  This file is part of LilyPond, the GNU music typesetter.

  Copyright (C) 1996--2012 Han-Wen Nienhuys <hanwen@xs4all.nl>
                 Jan Nieuwenhuizen <janneke@gnu.org>

  LilyPond is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  LilyPond is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with LilyPond.  If not, see <http://www.gnu.org/licenses/>.
*/

/* Mode and indentation are at best a rough approximation based on TAB
 * formatting (reasonable for compatibility with unspecific editor
 * modes as Flex modes are hard to find) and need manual correction
 * frequently.  Without a reasonably dependable way of formatting a
 * Flex file sensibly, there is little point in trying to fix the
 * inconsistent state of indentation.
 */

/*
  backup rules

  after making a change to the lexer rules, run 
      flex -b <this lexer file>
  and make sure that 
      lex.backup
  contains no backup states, but only the reminder
      Compressed tables always back up.
 (don-t forget to rm lex.yy.cc :-)
 */



#include <cstdio>
#include <cctype>
#include <cerrno>

/* Flex >= 2.5.29 fix; FlexLexer.h's multiple include bracing breaks
   when building the actual lexer.  */

#define LEXER_CC

#include <iostream>
using namespace std;

#include "context-def.hh"
#include "duration.hh"
#include "international.hh"
#include "interval.hh"
#include "lily-guile.hh"
#include "lily-lexer.hh"
#include "lily-parser.hh"
#include "lilypond-version.hh"
#include "main.hh"
#include "music.hh"
#include "music-function.hh"
#include "parse-scm.hh"
#include "parser.hh"
#include "pitch.hh"
#include "source-file.hh"
#include "std-string.hh"
#include "string-convert.hh"
#include "version.hh"
#include "warn.hh"

/*
RH 7 fix (?)
*/
#define isatty HORRIBLEKLUDGE

void strip_trailing_white (string&);
void strip_leading_white (string&);
string lyric_fudge (string s);
SCM lookup_markup_command (string s);
SCM lookup_markup_list_command (string s);
bool is_valid_version (string s);


#define start_quote()	\
	yy_push_state (quote);\
	yylval.string = new string

#define start_lyric_quote()	\
	yy_push_state (lyric_quote);\
	yylval.string = new string

#define yylval (*lexval_)

#define yylloc (*lexloc_)

#define YY_USER_ACTION	add_lexed_char (YYLeng ());


SCM scan_fraction (string);
SCM (* scm_parse_error_handler) (void *);



%}

%option c++
%option noyywrap
%option nodefault
%option debug
%option yyclass="Lily_lexer"
%option stack
%option never-interactive 
%option warn

%x extratoken
%x chords
%x figures
%x incl
%x lyrics
%x lyric_quote
%x longcomment
%x markup
%x notes
%x quote
%x sourcefileline
%x sourcefilename
%x version

/* The strategy concerning multibyte characters is to accept them but
 * call YYText_utf8 for patterns that might contain them, in order to
 * get a single code path responsible for flagging non-UTF-8 input:
 * Patterns for accepting only valid UTF-8 without backing up are
 * really hard to do and complex, and if nice error messages are
 * wanted, one would need patterns catching the invalid input as well.
 *
 * Since editors and operating environments don't necessarily behave
 * reasonably in the presence of mixed encodings, we flag encoding
 * errors also in identifiers, comments, and strings where it would be
 * conceivable to just transparently work with the byte string.  But
 * the whole point of caring about UTF-8 in here at all is too avoid
 * stranger errors later when input passes into backends or log files
 * or console output or error messages.
 */

A		[a-zA-Z\200-\377]
AA		{A}|_
N		[0-9]
AN		{AA}|{N}
ANY_CHAR	(.|\n)
PUNCT		[?!:'`]
ACCENT		\\[`'"^]
SPECIAL_CHAR		[&@]
NATIONAL	[\001-\006\021-\027\031\036]
TEX		{AA}|-|{PUNCT}|{ACCENT}|{NATIONAL}|{SPECIAL_CHAR}
DASHED_WORD		{A}({AN}|-)*
DASHED_KEY_WORD		\\{DASHED_WORD}



ALPHAWORD	{A}+
UNSIGNED	{N}+
E_UNSIGNED	\\{N}+
FRACTION	{N}+\/{N}+
INT		-?{UNSIGNED}
REAL		({INT}\.{N}*)|(-?\.{N}+)
WHITE		[ \n\t\f\r]
HORIZONTALWHITE		[ \t]
BLACK		[^ \n\t\f\r]
RESTNAME	[rs]
NOTECOMMAND	\\{A}+
MARKUPCOMMAND	\\({A}|[-_])+
LYRICS		({AA}|{TEX})[^0-9 \t\n\r\f]*
ESCAPED		[nt\\'"]
EXTENDER	__
HYPHEN		--
BOM_UTF8	\357\273\277

%%


<*>\r		{
	// swallow and ignore carriage returns
}

<extratoken>{ANY_CHAR}	{
  /* Generate a token without swallowing anything */

  /* First unswallow the eaten character */
  add_lexed_char (-YYLeng ());
  yyless (0);

  /* produce requested token */
  int type = scm_to_int (scm_caar (extra_tokens_));
  yylval.scm = scm_cdar (extra_tokens_);
  extra_tokens_ = scm_cdr (extra_tokens_);
  if (scm_is_null (extra_tokens_))
    yy_pop_state ();

  return type;
}

<extratoken><<EOF>>	{
  /* Generate a token without swallowing anything */

  /* produce requested token */
  int type = scm_to_int (scm_caar (extra_tokens_));
  yylval.scm = scm_cdar (extra_tokens_);
  extra_tokens_ = scm_cdr (extra_tokens_);
  if (scm_is_null (extra_tokens_))
    yy_pop_state ();

  return type;
}

   /* Use the trailing context feature. Otherwise, the BOM will not be
      found if the file starts with an identifier definition. */
<INITIAL,chords,lyrics,figures,notes>{BOM_UTF8}/.* {
  if (this->lexloc_->line_number () != 1 || this->lexloc_->column_number () != 0)
    {
      LexerWarning (_ ("stray UTF-8 BOM encountered").c_str ());
      // exit (1);
    }
  debug_output (_ ("Skipping UTF-8 BOM"));
}

<INITIAL,chords,figures,incl,lyrics,markup,notes>{
  "%{"	{
	yy_push_state (longcomment);
  }
  %[^{\n\r][^\n\r]*[\n\r]	{
	  (void) YYText_utf8 ();
  }
  %[^{\n\r]	{ // backup rule
	  (void) YYText_utf8 ();
  }
  %[\n\r]	{
  }
  %[^{\n\r][^\n\r]*	{
	  (void) YYText_utf8 ();
  }
  {WHITE}+ 	{

  }
}

<INITIAL,notes,figures,chords,markup>{
	\"		{
		start_quote ();
	}
}

<INITIAL,chords,lyrics,notes,figures>\\version{WHITE}*	{
	yy_push_state (version);
}
<INITIAL,chords,lyrics,notes,figures>\\sourcefilename{WHITE}*	{
	yy_push_state (sourcefilename);
}
<INITIAL,chords,lyrics,notes,figures>\\sourcefileline{WHITE}*	{
	yy_push_state (sourcefileline);
}
<version>\"[^"]*\"     { /* got the version number */
	string s (YYText_utf8 () + 1);
	s = s.substr (0, s.rfind ('\"'));

	yy_pop_state ();

	SCM top_scope = scm_car (scm_last_pair (scopes_));
	scm_module_define (top_scope, ly_symbol2scm ("version-seen"), SCM_BOOL_T);

	if (!is_valid_version (s))
		return INVALID;


}
<sourcefilename>\"[^"]*\"     {
	string s (YYText_utf8 () + 1);
	s = s.substr (0, s.rfind ('\"'));

	yy_pop_state ();
	this->here_input().get_source_file ()->name_ = s;
	message (_f ("Renaming input to: `%s'", s.c_str ()));
	progress_indication ("\n");
	scm_module_define (scm_car (scopes_),
		     ly_symbol2scm ("input-file-name"),
		     ly_string2scm (s));

}

<sourcefileline>{INT}	{
	int i;
	sscanf (YYText (), "%d", &i);

	yy_pop_state ();
	this->here_input ().get_source_file ()->set_line (here_input ().start (), i);
}

<version>{ANY_CHAR} 	{
	LexerError (_ ("quoted string expected after \\version").c_str ());
	yy_pop_state ();
}
<sourcefilename>{ANY_CHAR} 	{
	LexerError (_ ("quoted string expected after \\sourcefilename").c_str ());
	yy_pop_state ();
}
<sourcefileline>{ANY_CHAR} 	{
	LexerError (_ ("integer expected after \\sourcefileline").c_str ());
	yy_pop_state ();
}
<longcomment>{
	[^\%]* 		{
		(void) YYText_utf8 ();
	}
	\%*[^}%]*		{
		(void) YYText_utf8 ();
	}
	"%"+"}"		{
		yy_pop_state ();
	}
}


<INITIAL,chords,lyrics,notes,figures>\\maininput           {
	if (!is_main_input_)
	{
		start_main_input ();
		is_main_input_ = true;
	}
	else
		error (_ ("\\maininput not allowed outside init files"));
}

<INITIAL,chords,lyrics,figures,notes>\\include           {
	yy_push_state (incl);
}
<incl>\"[^""]*\"   { /* got the include file name */
	string s (YYText_utf8 ()+1);
	s = s.substr (0, s.rfind ('"'));

	new_input (s, sources_);
	yy_pop_state ();
}
<incl>\\{BLACK}*{WHITE}? { /* got the include identifier */
	string s = YYText_utf8 () + 1;
	strip_trailing_white (s);
	if (s.length () && (s[s.length () - 1] == ';'))
	  s = s.substr (0, s.length () - 1);

	SCM sid = lookup_identifier (s);
	if (scm_is_string (sid)) {
		new_input (ly_scm2string (sid), sources_);
		yy_pop_state ();
	} else {
	    string msg (_f ("wrong or undefined identifier: `%s'", s ));

	    LexerError (msg.c_str ());
	    SCM err = scm_current_error_port ();
	    scm_puts ("This value was found in the table: ", err);
	    scm_display (sid, err);
	  }
}
<incl>(\$|#) { // scm for the filename
	int n = 0;
	Input hi = here_input();
	hi.step_forward ();
	SCM sval = ly_parse_scm (hi.start (), &n, hi,
		be_safe_global && is_main_input_, parser_);
	sval = eval_scm (sval);

	for (int i = 0; i < n; i++)
	{
		yyinput ();
	}
	char_count_stack_.back () += n;

	if (scm_is_string (sval)) {
		new_input (ly_scm2string (sval), sources_);
		yy_pop_state ();
	} else {
		LexerError (_ ("string expected after \\include").c_str ());
		if (sval != SCM_UNDEFINED) {
			SCM err = scm_current_error_port ();
			scm_puts ("This value was found instead: ", err);
			scm_display (sval, err);
		}
	}
}

<incl,version,sourcefilename>\"[^""]*   { // backup rule
	error (_ ("end quote missing"));
	exit (1);
}
<chords,notes,figures>{RESTNAME} 	{
	char const *s = YYText ();
	yylval.scm = scm_from_locale_string (s);
	return RESTNAME;
}
<chords,notes,figures>q	{
	return CHORD_REPETITION;
}

<chords,notes,figures>R		{
	return MULTI_MEASURE_REST;
}
<INITIAL,chords,figures,lyrics,markup,notes>#	{ //embedded scm
	int n = 0;
	Input hi = here_input();
	hi.step_forward ();
	SCM sval = ly_parse_scm (hi.start (), &n, hi,
		be_safe_global && is_main_input_, parser_);

	if (sval == SCM_UNDEFINED)
		error_level_ = 1;

	for (int i = 0; i < n; i++)
	{
		yyinput ();
	}
	char_count_stack_.back () += n;

	yylval.scm = sval;
	return SCM_TOKEN;
}

<INITIAL,chords,figures,lyrics,markup,notes>\$	{ //immediate scm
	int n = 0;
	Input hi = here_input();
	hi.step_forward ();
	SCM sval = ly_parse_scm (hi.start (), &n, hi,
		be_safe_global && is_main_input_, parser_);

	for (int i = 0; i < n; i++)
	{
		yyinput ();
	}
	char_count_stack_.back () += n;

	sval = eval_scm (sval);
		
	int token = scan_scm_id (sval);
	if (!scm_is_eq (yylval.scm, SCM_UNSPECIFIED))
	  return token;
}

<INITIAL,notes,lyrics>{ 
	\<\<	{
		return DOUBLE_ANGLE_OPEN;
	}
	\>\>	{
		return DOUBLE_ANGLE_CLOSE;
	}
}

<INITIAL,notes>{
	\<	{
		return ANGLE_OPEN;
	}
	\>	{
		return ANGLE_CLOSE;
	}
}

<figures>{
	_	{
		return FIGURE_SPACE;
	}
	\>		{
		return FIGURE_CLOSE;
	}
	\< 	{
		return FIGURE_OPEN;
	}
}

<notes,figures>{
	{ALPHAWORD}	{
		return scan_bare_word (YYText_utf8 ());
	}

	{NOTECOMMAND}	{
		return scan_escaped_word (YYText_utf8 () + 1); 
	}
	{FRACTION}	{
		yylval.scm =  scan_fraction (YYText ());
		return FRACTION;
	}
	{UNSIGNED}/\/	| // backup rule
	{UNSIGNED}		{
		yylval.scm = scm_c_read_string (YYText ());
		return UNSIGNED;
	}
	{E_UNSIGNED}	{
		yylval.i = String_convert::dec2int (string (YYText () +1));
		return E_UNSIGNED;
	}
}

<quote,lyric_quote>{
	\\{ESCAPED}	{
		*yylval.string += to_string (escaped_char (YYText ()[1]));
	}
	[^\\""]+	{
		*yylval.string += YYText_utf8 ();
	}
	\"	{

		yy_pop_state ();

		/* yylval is union. Must remember STRING before setting SCM*/
		string *sp = yylval.string;
		yylval.scm = ly_string2scm (*sp);
		delete sp;
		return is_lyric_state () ? LYRICS_STRING : STRING;
	}
	\\	{
		*yylval.string += YYText ();
	}
}

<lyrics>{
	\" {
		start_lyric_quote ();
	}
	{FRACTION}	{
		yylval.scm =  scan_fraction (YYText ());
		return FRACTION;
	}
	{UNSIGNED}/\/[^0-9] { // backup rule
		yylval.scm = scm_c_read_string (YYText ());
		return UNSIGNED;
	}
	{UNSIGNED}/\/	| // backup rule
	{UNSIGNED}		{
		yylval.scm = scm_c_read_string (YYText ());
		return UNSIGNED;
	}
	{NOTECOMMAND}	{
		return scan_escaped_word (YYText_utf8 () + 1);
	}
	{LYRICS} {
		/* ugr. This sux. */
		string s (YYText_utf8 ()); 
		if (s == "__")
			return yylval.i = EXTENDER;
		if (s == "--")
			return yylval.i = HYPHEN;
		s = lyric_fudge (s);

		char c = s[s.length () - 1];
		if (c == '{' ||  c == '}') // brace open is for not confusing dumb tools.
			here_input ().warning (
				_ ("Brace found at end of lyric.  Did you forget a space?"));
		yylval.scm = ly_string2scm (s);


		return LYRICS_STRING;
	}
	. {
		return YYText ()[0]; // LYRICS already catches all multibytes.
	}
}
<chords>{
	{ALPHAWORD}	{
		return scan_bare_word (YYText_utf8 ());
	}
	{NOTECOMMAND}	{
		return scan_escaped_word (YYText_utf8 () + 1);
	}
	{FRACTION}	{
		yylval.scm =  scan_fraction (YYText ());
		return FRACTION;
	}
	{UNSIGNED}/\/[^0-9] { // backup rule
		yylval.scm = scm_c_read_string (YYText ());
		return UNSIGNED;
	}
	{UNSIGNED}/\/	| // backup rule
	{UNSIGNED}		{
		yylval.scm = scm_c_read_string (YYText ());
		return UNSIGNED;
	}
	-  {
		return CHORD_MINUS;
	}
	:  {
		return CHORD_COLON;
	}
	\/\+ {
		return CHORD_BASS;
	}
	\/  {
		return CHORD_SLASH;
	}
	\^  {
		return CHORD_CARET;
	}
	. {
		return YYText ()[0]; // ALPHAWORD catches all multibyte.
	}
}


<markup>{
	\\score {
		return SCORE;
	}
	{MARKUPCOMMAND} {
		string str (YYText_utf8 () + 1);

                int token_type = MARKUP_FUNCTION;
		SCM s = lookup_markup_command (str);

		// lookup-markup-command returns a pair with the car
		// being the function to call, and the cdr being the
		// call signature specified to define-markup-command,
		// a list of predicates.

                if (!scm_is_pair (s)) {
		  // If lookup-markup-command was not successful, we
		  // try lookup-markup-list-command instead.
		  // If this fails as well, we just scan and return
		  // the escaped word.
		  s = lookup_markup_list_command (str);
		  if (scm_is_pair (s))
		    token_type = MARKUP_LIST_FUNCTION;
		  else
		    return scan_escaped_word (str);
                }

		// If the list of predicates is, say,
		// (number? number? markup?), then tokens
		// EXPECT_MARKUP EXPECT_SCM EXPECT_SCM EXPECT_NO_MORE_ARGS
		// will be generated.  Note that we have to push them
		// in reverse order, so the first token pushed in the
		// loop will be EXPECT_NO_MORE_ARGS.

		yylval.scm = scm_car(s);

		// yylval now contains the function to call as token
		// value (for token type MARKUP_FUNCTION or
		// MARKUP_LIST_FUNCTION).

		push_extra_token(EXPECT_NO_MORE_ARGS);
		s = scm_cdr(s);
		for (; scm_is_pair(s); s = scm_cdr(s)) {
		  SCM predicate = scm_car(s);

		  if (predicate == ly_lily_module_constant ("markup-list?"))
		    push_extra_token(EXPECT_MARKUP_LIST);
		  else if (predicate == ly_lily_module_constant ("markup?"))
		    push_extra_token(EXPECT_MARKUP);
		  else
		    push_extra_token(EXPECT_SCM, predicate);
		}
		return token_type;
	}
	[{}]	{
		return YYText ()[0];
	}
	[^$#{}\"\\ \t\n\r\f]+ {
		string s (YYText_utf8 ()); 

		char c = s[s.length () - 1];
		/* brace open is for not confusing dumb tools.  */
		if (c == '{' ||  c == '}')
			here_input ().warning (
				_ ("Brace found at end of markup.  Did you forget a space?"));
		yylval.scm = ly_string2scm (s);


		return STRING;
	}
	.  {
		return YYText()[0];  // Above is catchall for multibyte
	}
}

<longcomment><<EOF>> {
		LexerError (_ ("EOF found inside a comment").c_str ());
		is_main_input_ = false; // should be safe , can't have \include in --safe.
		if (!close_input ())
		  yyterminate (); // can't move this, since it actually rets a YY_NULL
	}

<<EOF>> { if (is_main_input_)
	{
		/* 2 = init.ly + current file.
		   > because we're before closing, but is_main_input_ should
		   reflect after.
 		*/ 
		is_main_input_ = include_stack_.size () > 2;
		if (!close_input ())
 	        /* Returns YY_NULL */
			yyterminate ();
	}
	else if (!close_input ())
 	        /* Returns YY_NULL */
 	  	yyterminate ();
}

<INITIAL>{
	{DASHED_WORD}	{
		return scan_bare_word (YYText_utf8 ());
	}
	{DASHED_KEY_WORD}	{
		return scan_escaped_word (YYText_utf8 () + 1);
	}
}

-{UNSIGNED}	| // backup rule
{REAL}		{
	yylval.scm = scm_c_read_string (YYText ());
	return REAL;
}
-\.	{ // backup rule
	yylval.scm = scm_from_double (0.0);
	return REAL;
}

{UNSIGNED}	{
	yylval.scm = scm_c_read_string (YYText ());
	return UNSIGNED;
}


[{}]	{

	return YYText ()[0];
}
[*:=]		{
	char c = YYText ()[0];

	return c;
}

<INITIAL,notes,figures>.	{
	return YYText ()[0];
}

<INITIAL,lyrics,notes,figures>\\. {
    char c = YYText ()[1];

    switch (c) {
    case '>':
	return E_ANGLE_CLOSE;
    case '<':
	return E_ANGLE_OPEN;
    case '!':
	return E_EXCLAMATION;
    case '(':
	return E_OPEN;
    case ')':
	return E_CLOSE;
    case '[':
	return E_BRACKET_OPEN;
    case '+':
	return E_PLUS;
    case ']':
	return E_BRACKET_CLOSE;
    case '~':
	return E_TILDE;
    case '\\':
	return E_BACKSLASH;

    default:
	return E_CHAR;
    }
}

<*>.[\200-\277]*	{
	string msg = _f ("invalid character: `%s'", YYText_utf8 ());
	LexerError (msg.c_str ());
	return '%';  // Better not return half a utf8 character.
}

%%

/* Make the lexer generate a token of the given type as the next token. 
 TODO: make it possible to define a value for the token as well */
void
Lily_lexer::push_extra_token (int token_type, SCM scm)
{
	if (scm_is_null (extra_tokens_))
	{
		if (YY_START != extratoken)
			hidden_state_ = YY_START;
		yy_push_state (extratoken);
	}
	extra_tokens_ = scm_acons (scm_from_int (token_type), scm, extra_tokens_);
}

void
Lily_lexer::push_chord_state (SCM tab)
{
	pitchname_tab_stack_ = scm_cons (tab, pitchname_tab_stack_);
	yy_push_state (chords);
}

void
Lily_lexer::push_figuredbass_state ()
{
	yy_push_state (figures);
}

void
Lily_lexer::push_initial_state ()
{
	yy_push_state (INITIAL);
}

void
Lily_lexer::push_lyric_state ()
{
	yy_push_state (lyrics);
}

void
Lily_lexer::push_markup_state ()
{
	yy_push_state (markup);
}

void
Lily_lexer::push_note_state (SCM tab)
{
	pitchname_tab_stack_ = scm_cons (tab, pitchname_tab_stack_);
	yy_push_state (notes);
}

void
Lily_lexer::pop_state ()
{
	bool extra = (YYSTATE == extratoken);

	if (extra)
		yy_pop_state ();

	if (YYSTATE == notes || YYSTATE == chords)
		pitchname_tab_stack_ = scm_cdr (pitchname_tab_stack_);

	yy_pop_state ();

	if (extra) {
		hidden_state_ = YYSTATE;
		yy_push_state (extratoken);
	}
}

int
Lily_lexer::identifier_type (SCM sid)
{
	int k = try_special_identifiers (&yylval.scm , sid);
	return k >= 0  ? k : SCM_IDENTIFIER;
}


int
Lily_lexer::scan_escaped_word (string str)
{
	// use more SCM for this.

//	SCM sym = ly_symbol2scm (str.c_str ());

	int i = lookup_keyword (str);
 	if (i == MARKUP && is_lyric_state ())
 		return LYRIC_MARKUP;
	if (i != -1)
		return i;

	SCM sid = lookup_identifier (str);
	if (sid != SCM_UNDEFINED)
		return scan_scm_id (sid);

	string msg (_f ("unknown escaped string: `\\%s'", str));	
	LexerError (msg.c_str ());

	yylval.scm = ly_string2scm (str);

	return STRING;
}

int
Lily_lexer::scan_scm_id (SCM sid)
{
	if (is_music_function (sid))
	{
		int funtype = SCM_FUNCTION;

		yylval.scm = get_music_function_transform (sid);

		SCM s = scm_object_property (yylval.scm, ly_symbol2scm ("music-function-signature"));
		SCM cs = scm_car (s);

		if (scm_is_pair (cs))
		{
			cs = SCM_CAR (cs);
		}

		if (scm_is_eq (cs, ly_lily_module_constant ("ly:music?")))
			funtype = MUSIC_FUNCTION;
		else if (scm_is_eq (cs, ly_lily_module_constant ("ly:event?")))
			funtype = EVENT_FUNCTION;
		else if (ly_is_procedure (cs))
			funtype = SCM_FUNCTION;
		else programming_error ("Bad syntax function predicate");

		push_extra_token (EXPECT_NO_MORE_ARGS);
		for (s = scm_cdr (s); scm_is_pair (s); s = scm_cdr (s))
		{
			SCM optional = SCM_UNDEFINED;
			cs = scm_car (s);

			if (scm_is_pair (cs))
			{
				optional = SCM_CDR (cs);
				cs = SCM_CAR (cs);
			}
			
			if (cs == Pitch_type_p_proc)
				push_extra_token (EXPECT_PITCH);
			else if (cs == Duration_type_p_proc)
				push_extra_token (EXPECT_DURATION);
			else if (ly_is_procedure (cs))
				push_extra_token (EXPECT_SCM, cs);
			else
			{
				programming_error ("Function parameter without type-checking predicate");
				continue;
			}
			if (!scm_is_eq (optional, SCM_UNDEFINED))
				push_extra_token (EXPECT_OPTIONAL, optional);
		}
		return funtype;
	}
	yylval.scm = sid;
	return identifier_type (sid);
}

int
Lily_lexer::scan_bare_word (string str)
{
	SCM sym = ly_symbol2scm (str.c_str ());
	if ((YYSTATE == notes) || (YYSTATE == chords)) {
		SCM handle = SCM_BOOL_F;
		if (scm_is_pair (pitchname_tab_stack_))
			handle = scm_hashq_get_handle (scm_car (pitchname_tab_stack_), sym);
		
		if (scm_is_pair (handle)) {
			yylval.scm = scm_cdr (handle);
			if (unsmob_pitch (yylval.scm)) 
	                    return (YYSTATE == notes) ? NOTENAME_PITCH : TONICNAME_PITCH;
			else if (scm_is_symbol (yylval.scm))
			    return DRUM_PITCH;
		}
		else if ((YYSTATE == chords)
		     	&& (handle = scm_hashq_get_handle (chordmodifier_tab_, sym))!= SCM_BOOL_F)
		{
		    yylval.scm = scm_cdr (handle);
		    return CHORD_MODIFIER;
		}
	}
	yylval.scm = ly_string2scm (str);
	return STRING;
}

int
Lily_lexer::get_state () const
{
	if (YY_START == extratoken)
		return hidden_state_;
	else
		return YY_START;
}

bool
Lily_lexer::is_note_state () const
{
	return get_state () == notes;
}

bool
Lily_lexer::is_chord_state () const
{
	return get_state () == chords;
}

bool
Lily_lexer::is_lyric_state () const
{
	return get_state () == lyrics;
}

bool
Lily_lexer::is_figure_state () const
{
	return get_state () == figures;
}

SCM
Lily_lexer::eval_scm (SCM readerdata)
{
	SCM sval = SCM_UNDEFINED;

	if (!SCM_UNBNDP (readerdata))
	{
		sval = ly_eval_scm (scm_car (readerdata),
				    *unsmob_input (scm_cdr (readerdata)),
				    be_safe_global && is_main_input_,
				    parser_);
	}

	if (SCM_UNBNDP (sval))
	{
		error_level_ = 1;
		return SCM_UNSPECIFIED;
	}
	return sval;
}

/* Check for valid UTF-8 that has no overlong or surrogate codes and
   is in the range 0-0x10ffff */

const char *
Lily_lexer::YYText_utf8 ()
{
	const char * const p =  YYText ();
	for (int i=0; p[i];) {
		if ((p[i] & 0xff) < 0x80) {
			++i;
			continue;
		}
		int oldi = i; // start of character
		int more = 0; // # of followup bytes, 0 if bad
		switch (p[i++] & 0xff) {
			// 0xc0 and 0xc1 are overlong prefixes for
			// 0x00-0x3f and 0x40-0x7f respectively, bad.
		case 0xc2:	// 0x80-0xbf
		case 0xc3:	// 0xc0-0xff
		case 0xc4:	// 0x100-0x13f
		case 0xc5:	// 0x140-0x17f
		case 0xc6:	// 0x180-0x1bf
		case 0xc7:	// 0x1c0-0x1ff
		case 0xc8:	// 0x200-0x23f
		case 0xc9:	// 0x240-0x27f
		case 0xca:	// 0x280-0x2bf
		case 0xcb:	// 0x2c0-0x2ff
		case 0xcc:	// 0x300-0x33f
		case 0xcd:	// 0x340-0x37f
		case 0xce:	// 0x380-0x3bf
		case 0xcf:	// 0x3c0-0x3ff
		case 0xd0:	// 0x400-0x43f
		case 0xd1:	// 0x440-0x47f
		case 0xd2:	// 0x480-0x4bf
		case 0xd3:	// 0x4c0-0x4ff
		case 0xd4:	// 0x500-0x53f
		case 0xd5:	// 0x540-0x57f
		case 0xd6:	// 0x580-0x5bf
		case 0xd7:	// 0x5c0-0x5ff
		case 0xd8:	// 0x600-0x63f
		case 0xd9:	// 0x640-0x67f
		case 0xda:	// 0x680-0x6bf
		case 0xdb:	// 0x6c0-0x6ff
		case 0xdc:	// 0x700-0x73f
		case 0xdd:	// 0x740-0x77f
		case 0xde:	// 0x780-0x7bf
		case 0xdf:	// 0x7c0-0x7ff
			more = 1; // 2-byte sequences, 0x80-0x7ff
			break;
		case 0xe0:
			// don't allow overlong sequences for 0-0x7ff
			if ((p[i] & 0xff) < 0xa0)
				break;
		case 0xe1:	// 0x1000-0x1fff
		case 0xe2:	// 0x2000-0x2fff
		case 0xe3:	// 0x3000-0x3fff
		case 0xe4:	// 0x4000-0x4fff
		case 0xe5:	// 0x5000-0x5fff
		case 0xe6:	// 0x6000-0x6fff
		case 0xe7:	// 0x7000-0x7fff
		case 0xe8:	// 0x8000-0x8fff
		case 0xe9:	// 0x9000-0x9fff
		case 0xea:	// 0xa000-0xafff
		case 0xeb:	// 0xb000-0xbfff
		case 0xec:	// 0xc000-0xcfff
			more = 2; // 3-byte sequences, 0x7ff-0xcfff
			break;
		case 0xed:	// 0xd000-0xdfff
			// Don't allow surrogate codes 0xd800-0xdfff
			if ((p[i] & 0xff) >= 0xa0)
				break;
		case 0xee:	// 0xe000-0xefff
		case 0xef:	// 0xf000-0xffff
			more = 2; // 3-byte sequences,
				  // 0xd000-0xd7ff, 0xe000-0xffff
			break;
		case 0xf0:
			// don't allow overlong sequences for 0-0xffff
			if ((p[i] & 0xff) < 0x90)
				break;
		case 0xf1:	// 0x40000-0x7ffff
		case 0xf2:	// 0x80000-0xbffff
		case 0xf3:	// 0xc0000-0xfffff
			more = 3; // 4-byte sequences, 0x10000-0xfffff
			break;
		case 0xf4:
			// don't allow more than 0x10ffff
			if ((p[i] & 0xff) >= 0x90)
				break;
			more = 3; // 4-byte sequence, 0x100000-0x10ffff
			break;
		}
		if (more) {
			// check that all continuation bytes are valid
			do {
				if ((p[i++] & 0xc0) != 0x80)
					break;
			} while (--more);
			if (!more)
				continue;
		}
		Input h = here_input ();
		h.set (h.get_source_file (), h.start () + oldi, h.start () + i);
		h.warning (_ ("non-UTF-8 input").c_str ());
	}
	return p;
}


/*
 urg, belong to string (_convert)
 and should be generalised 
 */
void
strip_leading_white (string&s)
{
	ssize i = 0;
	for (;  i < s.length (); i++)
		if (!isspace (s[i]))
			break;

	s = s.substr (i);
}

void
strip_trailing_white (string&s)
{
	ssize i = s.length ();	
	while (i--) 
		if (!isspace (s[i]))
			break;

	s = s.substr (0, i + 1);
}



Lilypond_version oldest_version ("2.7.38");


bool
is_valid_version (string s)
{
  Lilypond_version current ( MAJOR_VERSION "." MINOR_VERSION "." PATCH_LEVEL );
  Lilypond_version ver (s);
  if (int (ver) < oldest_version)
	{	
		non_fatal_error (_f ("file too old: %s (oldest supported: %s)", ver.to_string (), oldest_version.to_string ()));
		non_fatal_error (_ ("consider updating the input with the convert-ly script"));
		return false;
	}

  if (ver > current)
	{
		non_fatal_error (_f ("program too old: %s (file requires: %s)",  current.to_string (), ver.to_string ()));
		return false;
	}
  return true;
}
	

/*
  substitute _
*/
string
lyric_fudge (string s)
{
	size_t i=0;

	while ((i = s.find ('_', i)) != string::npos)
	{
		s[i++] = ' ';
	}
	return s;
}

/*
Convert "NUM/DEN" into a '(NUM . DEN) cons.
*/
SCM
scan_fraction (string frac)
{
	ssize i = frac.find ('/');
	string left = frac.substr (0, i);
	string right = frac.substr (i + 1, (frac.length () - i + 1));

	int n = String_convert::dec2int (left);
	int d = String_convert::dec2int (right);
	return scm_cons (scm_from_int (n), scm_from_int (d));
}

SCM
lookup_markup_command (string s)
{
	SCM proc = ly_lily_module_constant ("lookup-markup-command");
	return scm_call_1 (proc, ly_string2scm (s));
}

SCM
lookup_markup_list_command (string s)
{
	SCM proc = ly_lily_module_constant ("lookup-markup-list-command");
	return scm_call_1 (proc, ly_string2scm (s));
}

/* Shut up lexer warnings.  */
#if YY_STACK_USED

static void
yy_push_state (int)
{
}

static void
yy_pop_state ()
{
}

static int
yy_top_state ()
{
  return 0;
}

static void
silence_lexer_warnings ()
{
   (void) yy_start_stack_ptr;
   (void) yy_start_stack_depth;
   (void) yy_start_stack;
   (void) yy_push_state;
   (void) yy_pop_state;
   (void) yy_top_state;
   (void) silence_lexer_warnings;
}
#endif

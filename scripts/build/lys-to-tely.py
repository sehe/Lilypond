#!@PYTHON@


'''
TODO:

 * Add @nodes, split at sections?

 * -o --output   listed in help is not implemented?!
'''


import sys
import os
import getopt
import re
import glob

program_name = 'lys-to-tely'

include_snippets = '@lysnippets'
fragment_options = 'printfilename,texidoc'
help_text = r"""Usage: %(program_name)s [OPTIONS]... LY-FILE...
Construct tely doc from LY-FILEs.

Options:
 -h, --help                     print this help
 -f, --fragment-options=OPTIONS use OPTIONS as lilypond-book fragment
   options
 -o, --output=NAME              write tely doc to NAME
 -i, --input-filenames=NAME     read list of files from a file instead of stdin
 -g, --glob-input=GLOB          a string which will be passed to glob.glob(GLOB)
 -t, --title=TITLE              set tely doc title TITLE
 -a, --author=AUTHOR            set tely author AUTHOR
     --template=TEMPLATE        use TEMPLATE as Texinfo template file,
   instead of standard template; TEMPLATE should contain a command
   '%(include_snippets)s' to tell where to insert LY-FILEs.  When this
   option is used, NAME and TITLE are ignored.
"""

def help (text):
    sys.stdout.write ( text)
    sys.exit (0)

(options, files) = getopt.getopt (sys.argv[1:], 'f:hn:t:',
                     ['fragment-options=', 'help', 'name=',
                     'title=', 'author=', 'template=',
                     'input-filenames=', 'glob-input='])

name = "ly-doc"
title = "Ly Doc"
author = "Han-Wen Nienhuys and Jan Nieuwenhuizen"
input_filename = ""
glob_input = ""
template = '''\input texinfo
@setfilename %%(name)s.info
@settitle %%(title)s

@documentencoding utf-8
@iftex
@afourpaper
@end iftex

@finalout @c we do not want black boxes.

@c fool ls-latex
@ignore
@author %%(author)s
@title %%(title)s
@end ignore

@node Top, , , (dir)
@top %%(title)s

%s

@bye
''' % include_snippets

for opt in options:
    o = opt[0]
    a = opt[1]
    if o == '-h' or o == '--help':
        # We can't use vars () inside a function, as that only contains all
        # local variables and none of the global variables! Thus we have to
        # generate the help text here and pass it to the function...
        help (help_text % vars ())
    elif o == '-n' or o == '--name':
        name = a
    elif o == '-t' or o == '--title':
        title = a
    elif o == '-a' or o == '--author':
        author = a
    elif o == '-i' or o == '--input-filenames':
        input_filename = a
    elif o == '-p' or o == '--glob-input':
        glob_input = a
    elif o == '-f' or o == '--fragment-options':
        fragment_options = a
    elif o == '--template':
        template = open (a, 'r').read ()
    else:
        raise Exception ('unknown option: ' + o)

html_file_re = re.compile ('.*\.i?html?$')
info_file_re = re.compile ('.*\.info$')
pdf_file_re = re.compile ('.*\.i?pdf$')
tex_file_re = re.compile ('.*\.i?(la)?tex$')
texi_file_re = re.compile ('.*\.i?te(ly|xi|xinfo)$')
xml_file_re = re.compile ('.*\.i?(xm|mx)l$')

def name2line (n):
    if texi_file_re.match (n):
        # We have a texi include file, simply include it:
        s = r"@include %s" % os.path.basename (n)
    elif (html_file_re.match (n) or info_file_re.match (n)
          or pdf_file_re.match (n) or tex_file_re.match (n)):
        s = r"""
@ifhtml
@html
<a href="%s">%s</a>
<br/>
@end html
@end ifhtml
""" % (os.path.basename (n), os.path.basename (n))

    elif (xml_file_re.match (n)):
        # Assume it's a MusicXML file -> convert, create image etc.
        s = r"""
@ifhtml
@html
<a name="%s"></a>
@end html
@end ifhtml

@musicxmlfile[%s]{%s}
""" % (os.path.basename (n), fragment_options, n)

    else:
        # Assume it's a lilypond file -> create image etc.
        s = r"""
@ifhtml
@html
<a name="%s"></a>
@end html
@end ifhtml

@lilypondfile[%s]{%s}
""" % (os.path.basename (n), fragment_options, n)
    return s

if glob_input:
    files = glob.glob(glob_input)
elif input_filename:
    files = open(input_filename).read().split()

if files:
    dir = os.path.dirname (name) or "."
# don't strip .tely extension, Documentation/snippets uses .itely
    name = os.path.basename (name)
    template = template % vars ()

    s = "\n".join (map (name2line, files))
    s = template.replace (include_snippets, s, 1)
    f = "%s/%s" % (dir, name)
    sys.stderr.write ("%s: writing %s..." % (program_name, f))
    h = open (f, "w")
    h.write (s)
    h.close ()
    sys.stderr.write ('\n')
else:
    # not Unix philosophy, but hey, at least we notice when
    # we don't distribute any .ly files.
    sys.stderr.write ("No files specified. Doing nothing")

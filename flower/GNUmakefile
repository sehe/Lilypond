depth = ..

NAME = flower
MODULE_NAME = flower
SUBDIRS = include

SCRIPTS =
README_FILES = NEWS-1.0 NEWS-1.1.46 README TODO
EXTRA_DIST_FILES= VERSION $(README_FILES) $(SCRIPTS)
STEPMAKE_TEMPLATES=library c++ po test

# test uses LILYPOND_DATADIR
LOCALSTEPMAKE_TEMPLATES=lilypond
TEST_MODULE_LIBS = ../flower
export top-src-dir
include $(depth)/make/stepmake.make

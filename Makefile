###########################################################################
#
# A Makefile template for programming in c/c++ under CLI
#
# Author: Zimin Wang (simon.zmwang@gmail.com)
#
# Usage:
#   $ make             Compile and link
#   $ make clean       Clean the objectives and target
#   $ make cleanobj    Clean the objectives 
#
###########################################################################
OPTIMIZE := -O0
WARNINGS := -Wall -Wno-unused -Wno-format -pedantic
DEFS :=
EXTRA_CFLAGS := -c -g

CC := cc
CXX := c++

CFLAGS := $(EXTRA_CFLAGS) $(WARNINGS) $(OPTIMIZE) $(DEFS)
SUFFIX := cpp
TARGET := testScoreList

all_srcs := $(wildcard *.$(SUFFIX))
all_objs := $(all_srcs:.$(SUFFIX)=.o)

DEP := $(patsubst %.$(SUFFIX),.%.d,$(all_srcs))
######################################################################
# You do not need to modify the following commands.
###################################################################### 

PHONY = all clean cleanobj

all: $(TARGET)

ifeq ($(SUFFIX),c)
$(TARGET): $(all_objs)
	$(CC) -o $@ $^
$(all_objs): %.o:%.$(SUFFIX)
	$(CC) $(CFLAGS) $<
else
$(TARGET): $(all_objs)
	$(CXX) -o $@ $^
$(all_objs): %.o:%.$(SUFFIX)
	$(CXX) $(CFLAGS) $<
endif

# automatic header file dependencies
$(DEP): .%.d:%.$(SUFFIX)
	@set -e; rm -rf $@; \
	$(CC) -MM $< >$@.$$$$; \
	sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' <$@.$$$$ >$@;\
	rm -rf $@.$$$$;
-include $(DEP)

clean: cleanobj
	rm -rf $(TARGET) $(DEP)

cleanobj:
	rm -rf $(all_objs)

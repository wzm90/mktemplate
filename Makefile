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
EXTRA_CFLAGS :=

CC := cc
CPP := clang++

CFLAGS := $(EXTRA_CFLAGS) $(WARNINGS) $(OPTIMIZE) $(DEFS)
SUFFIX := cpp
TARGET := testScoreList

all_srcs := $(wildcard *.$(SUFFIX))
all_objs := $(all_srcs:.$(SUFFIX)=.o)

# whether to link with c++
linkCC := 1


#DEP := $(foreach i,$(SUFFIX),$(patsubst %.$(i),.%.d,$(all_srcs)))
#DEP := $(foreach f,$(all_srcs),$(patsubst %.$(suffix $(f)),.%.d,$(f)))
DEP := $(patsubst %.$(SUFFIX),.%.d,$(all_srcs))

PHONY = all clean cleanobj

all: $(TARGET)

ifeq ($(linkCC),0)
$(TARGET): $(all_objs)
	$(CC) -o $@ $^
else
$(TARGET): $(all_objs)
	$(CPP) -o $@ $^
endif

$(all_objs): %.o:%.$(SUFFIX)
	$(CPP) -c $< $(CFLAGS)

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

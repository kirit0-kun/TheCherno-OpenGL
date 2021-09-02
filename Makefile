TARGET=the_cherno
CC=g++
CFLAGS=-g -Wall -framework OpenGL -framework Cocoa -framework IOKit -framework CoreVideo #-target x86_64-apple-darwin20.6.0

GLEW=glew-2.1.0
GLFW=glfw-3.3.4

DEPENDENCIES_DIR=Dependencies
DEPENDENCIES=$(GLFW) $(GLEW)
DEPENDENCIES_LIB_LOC=$(GLFW)/build/src $(GLEW)/lib

BASE_LIBS_LOC=. $(patsubst %, $(DEPENDENCIES_DIR)/%, $(DEPENDENCIES_LIB_LOC))
BASE_LIBS=c glfw3 GLEW
BASE_INC=. headers
SRCDIR= src
SRCEXT=cpp
BUILDDIR= build
BASE_SRCS=main

INC=$(patsubst %, -I%, $(BASE_INC)) $(patsubst %, -I$(DEPENDENCIES_DIR)/%/include, $(DEPENDENCIES))
LIBS_LOC=$(patsubst %, -L%, $(BASE_LIBS_LOC))
LIBS=$(patsubst %, -l%, $(BASE_LIBS))
SRCS=$(patsubst %, $(SRCDIR)/%.$(SRCEXT), $(BASE_SRCS))
OBJS = $(patsubst %, $(BUILDDIR)/%, $(notdir $(SRCS:.$(SRCEXT)=.o)))

all: buildFiles
	./${TARGET}

leaks: buildFiles
	./${TARGET}

buildFiles: $(BUILDDIR) $(TARGET)

$(BUILDDIR)/%.o: $(SRCDIR)/%.$(SRCEXT)
	$(CC) $(CFLAGS) $(INC) -c $< -o $@
	$(CC) $(CFLAGS) $(INC) -S $< -o $(@:.o=.s)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) $(LIBS_LOC) $(LIBS) -o $@ $^

$(BUILDDIR):
	mkdir -p $(BUILDDIR)

clean:
	rm -f -r *.o $(TARGET) *.s *.h.gch *.dSYM $(BUILDDIR)

clear: clean
	clear
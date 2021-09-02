TARGET=the_cherno
CC=gcc
CFLAGS=-g -Wall

LIBS=-lc
INC=-I. -Iheaders

SRCDIR= src
BUILDDIR= build

SRCS=main.c

RELATIVE_SRCS=$(patsubst %, $(SRCDIR)/%, $(SRCS))

OBJS = $(patsubst %, $(BUILDDIR)/%, $(notdir $(RELATIVE_SRCS:.c=.o)))

all: buildFiles
	./$(BUILDDIR)/${TARGET}

leaks: buildFiles
	./$(BUILDDIR)/${TARGET}

buildFiles: $(BUILDDIR) $(TARGET)

$(BUILDDIR)/%.o: $(SRCDIR)/%.c
	$(CC) $(CFLAGS) $(INC) -c $< -o $@
	$(CC) $(CFLAGS) $(INC) -S $< -o $(@:.o=.s)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) $(LIBS) -o $(BUILDDIR)/$@ $^

$(BUILDDIR):
	mkdir -p $(BUILDDIR)

clean:
	rm -f -r *.o $(TARGET) *.s *.h.gch *.dSYM $(BUILDDIR)

clear: clean
	clear
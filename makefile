SOURCES=  bcalc.y  scan.l 
objects = bcalc.o scan.o

BISON=bison
FLEX=flex
CC=g++
CFLAGS = -O0 -g -c -std=c++11 -Wno-write-strings

TARGET = bcalc.exe
all: $(TARGET)

bcalc.exe: ${objects}
	${CC} -o $@ ${objects} -lfl 

.SUFFIXES: .c .y .l .o .e

.y.c:
	${BISON} -d -o `basename $< .y`.c  $<
.l.c:   
	${FLEX} -o `basename $< .l`.c  $<
.c.o:
	${CC} ${CFLAGS} $<


clean:
	rm -rf bcalc.exe *.o *~ scan.c bcalc.c bcalc.h y.tab.c y.tab.h


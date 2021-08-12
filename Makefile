
CXX = g++
CXXFLAGS = -O3 -Wall -std=c++11 -mavx -mavx2
LIBS = -lz -lzstd
INC = -I/usr/local/include
LPATHS = -L/usr/local/lib

OBJ = \
		src/main.o \
		src/bgen.o \
		src/genotypes.o \
		src/header.o \
		src/samples.o \
		src/utils.o \
		src/variant.o \

program = print-dosages
all: ${program}

${program}: ${OBJ}
		${CXX} ${CXXFLAGS} -o ${program} ${OBJ} ${LPATHS} ${LIBS}

%.o: %.cpp
		${CXX} ${CXXFLAGS} -o $@ -c $< ${INC}

clean:
		rm -f ${OBJ} ${program}

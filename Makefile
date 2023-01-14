VERSION = 0.0.1

# paths
PREFIX = /usr/local
MANPREFIX = ${PREFIX}/share/man

X11INC = /usr/X11R6/include
X11LIB = -lX11

# Xinerama, comment if you don't want it
XINERAMAFLAGS = -DXINERAMA
XINERAMALIBS  = -lXinerama

# freetype
FREETYPEINC = /usr/include/freetype2
FREETYPELIBS = -lfontconfig -lXft

# includes and libs
INCS = -Iinc/ -I${X11INC} -I${FREETYPEINC}

# flags
WARNINGS = -Wpedantic -Wall -Wextra -Wno-deprecated-declarations 
CXXFLAGS = -std=c++20 ${INCS} -D_DEFAULT_SOURCE -DVERSION=\"${VERSION}\" ${XINERAMAFLAGS}
LDFLAGS  = -lstdc++ ${X11LIB} ${XINERAMALIBS} ${FREETYPELIBS}

# compiler and linker
CXX = c++

SRC = $(wildcard src/*.cpp)
OBJ = ${SRC:.cpp=.o}
BIN = $(wildcard build/*.o)

all: options ezdwm

options:
	@mkdir -p build
	@echo build options:
	@echo "CXXFLAGS = ${CXXFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CXX      = ${CXX}"

.cpp.o:
	${CXX} -o build/$(@F) -c ${CXXFLAGS} $<
	# @echo "${CXX} -o build/$(@F) -c ${CXXFLAGS} $<"

ezdwm: ${OBJ}
	${CXX} -o build/$(@F) ${BIN} ${LDFLAGS}
	# @echo "${CXX} -o build/$(@F) ${BIN} ${LDFLAGS}"
	# make | grep -wE 'c\+\+' | grep -w '\-c'  | sed 's|cd.*.\&\&||g' | jq -nR '[inputs|{directory:".", command:., file: match(" [^ ]+$").string[1:]}]' > build/compile_commands.json

clean:
	rm -f build
	rm -f ezdwm-${VERSION}.tar.gz

dist: clean
	mkdir -p ezdwm-${VERSION}/src
	cp -R .gitignore ezdwm-${VERSION}
	cp -R CMakeLists.txt ezdwm-${VERSION}
	cp -R Makefile ezdwm-${VERSION}
	cp -R doc ezdwm-${VERSION}
	cp -R inc ezdwm-${VERSION}
	cp -R src ezdwm-${VERSION}
	tar -cf ezdwm-${VERSION}.tar ezdwm-${VERSION}
	gzip ezdwm-${VERSION}.tar
	rm -rf ezdwm-${VERSION}

install: all
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp -f build/ezdwm ${DESTDIR}${PREFIX}/bin
	chmod 755 ${DESTDIR}${PREFIX}/bin/ezdwm
	mkdir -p ${DESTDIR}${MANPREFIX}/man1
	sed "s/VERSION/${VERSION}/g" < ezdwm.1 > ${DESTDIR}${MANPREFIX}/man1/ezdwm.1
	chmod 644 ${DESTDIR}${MANPREFIX}/man1/ezdwm.1

uninstall:
	rm -f ${DESTDIR}${PREFIX}/bin/ezdwm
	rm -f ${DESTDIR}${MANPREFIX}/man1/ezdwm.1

.PHONY: all options .cpp.o ezdwm clean dist install uninstall

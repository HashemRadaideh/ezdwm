VERSION = 0.0.1

# paths
PREFIX = /usr/local
MANPREFIX = ${PREFIX}/share/man

X11INC = /usr/X11R6/include
X11LIB = /usr/X11R6/lib

# Xinerama, comment if you don't want it
XINERAMAFLAGS = -DXINERAMA
XINERAMALIBS  = -lXinerama

# freetype
FREETYPEINC = /usr/include/freetype2
FREETYPELIBS = -lfontconfig -lXft

# includes and libs
INCS = -Iinc/ -I${X11INC} -I${FREETYPEINC}
LIBS = -lstdc++ -L${X11LIB} -lX11 ${XINERAMALIBS} ${FREETYPELIBS}

# flags
CXXFLAGS = -std=c++20 -Wpedantic -Wall -Wextra -Wno-deprecated-declarations ${INCS} -D_DEFAULT_SOURCE -DVERSION=\"${VERSION}\" ${XINERAMAFLAGS}
LDFLAGS  = ${LIBS}

# compiler and linker
CXX = c++

SRC = src/drw.cpp src/main.cpp src/util.cpp
OBJ = ${SRC:.cpp=.o}

all: options ezdwm

options:
	@echo build options:
	@echo "CXXFLAGS = ${CXXFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CXX      = ${CXX}"

.c.o:
	${CXX} -c ${CXXFLAGS} $<

ezdwm: ${OBJ}
	mkdir	-p build
	${CXX} -o build/$@ ${OBJ} ${LDFLAGS}
	rm -f ${OBJ}

clean:
	rm -f build/ezdwm ${OBJ} ezdwm-${VERSION}.tar.gz

dist: clean
	mkdir -p ezdwm-${VERSION}/src
	cp -R Makefile ezdwm.1 ezdwm-${VERSION}
	cp -R inc/config.hpp  inc/drw.hpp inc/util.hpp inc/x.hpp ${SRC} ezdwm-${VERSION}/src
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
	rm -f ${DESTDIR}${PREFIX}/bin/ezdwm ${DESTDIR}${MANPREFIX}/man1/ezdwm.1

.PHONY: all options clean dist install uninstall

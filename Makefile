include config.mk

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

${OBJ}: src/config.hpp config.mk

src/config.hpp:
	cp src/config.def.hpp $@

ezdwm: ${OBJ}
	${CXX} -o $@ ${OBJ} ${LDFLAGS}

clean:
	rm -f ezdwm ${OBJ} ezdwm-${VERSION}.tar.gz

dist: clean
	mkdir -p ezdwm-${VERSION}/src
	cp -R Makefile config.mk ezdwm.1 icon.png ezdwm-${VERSION}
	cp -R src/config.def.hpp  src/drw.hpp src/util.hpp src/x.hpp ${SRC} ezdwm-${VERSION}/src
	tar -cf ezdwm-${VERSION}.tar ezdwm-${VERSION}
	gzip ezdwm-${VERSION}.tar
	rm -rf ezdwm-${VERSION}

install: all
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp -f ezdwm ${DESTDIR}${PREFIX}/bin
	chmod 755 ${DESTDIR}${PREFIX}/bin/ezdwm
	mkdir -p ${DESTDIR}${MANPREFIX}/man1
	sed "s/VERSION/${VERSION}/g" < ezdwm.1 > ${DESTDIR}${MANPREFIX}/man1/ezdwm.1
	chmod 644 ${DESTDIR}${MANPREFIX}/man1/ezdwm.1

uninstall:
	rm -f ${DESTDIR}${PREFIX}/bin/ezdwm\
		${DESTDIR}${MANPREFIX}/man1/ezdwm.1

.PHONY: all options clean dist install uninstall

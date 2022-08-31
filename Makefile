include config.mk

SRC = src/drw.cpp src/main.cpp src/util.cpp
OBJ = ${SRC:.cpp=.o}

all: options ultra

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

ultra: ${OBJ}
	${CXX} -o $@ ${OBJ} ${LDFLAGS}

clean:
	rm -f ultra ${OBJ} ultra-${VERSION}.tar.gz

dist: clean
	mkdir -p ultra-${VERSION}/src
	cp -R Makefile config.mk ultra.1 icon.png ultra-${VERSION}
	cp -R src/config.def.hpp  src/drw.hpp src/util.hpp src/x.hpp ${SRC} ultra-${VERSION}/src
	tar -cf ultra-${VERSION}.tar ultra-${VERSION}
	gzip ultra-${VERSION}.tar
	rm -rf ultra-${VERSION}

install: all
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp -f ultra ${DESTDIR}${PREFIX}/bin
	chmod 755 ${DESTDIR}${PREFIX}/bin/ultra
	mkdir -p ${DESTDIR}${MANPREFIX}/man1
	sed "s/VERSION/${VERSION}/g" < ultra.1 > ${DESTDIR}${MANPREFIX}/man1/ultra.1
	chmod 644 ${DESTDIR}${MANPREFIX}/man1/ultra.1

uninstall:
	rm -f ${DESTDIR}${PREFIX}/bin/ultra\
		${DESTDIR}${MANPREFIX}/man1/ultra.1

.PHONY: all options clean dist install uninstall

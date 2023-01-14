VERSION = 0.0.1

# compiler and linker
CXX = c++

SRC = $(wildcard src/*.cpp)
OBJ = $(patsubst %,build/%, $(notdir $(SRC:.cpp=.o)))

# paths
PREFIX = /usr/local
MANPREFIX = $(PREFIX)/share/man

# x11 includes and lib
X11INC = -I/usr/X11R6/include
X11LIB = -lX11

# Xinerama lib
XINERAMAFLAG = -DXINERAMA
XINERAMALIBS  = -lXinerama

# freetype
FREETYPEINC = -I/usr/include/freetype2
FREETYPELIB = -lfontconfig -lXft

# includes and libs
INCS = $(X11INC) $(FREETYPEINC) -Iinc/
LIBS = $(X11LIB) $(FREETYPELIB) $(XINERAMALIBS)

# warnings and macros
WARNINGS = -Wall -Wpedantic -Wextra -Wno-deprecated-declarations
MACROS   = -DVERSION=\"$(VERSION)\" -D_DEFAULT_SOURCE $(XINERAMAFLAG)

# flags
CXXFLAGS = -std=c++20 $(INCS) $(MACROS) $(WARNINGS)
LDFLAGS  = -lstdc++ $(LIBS)

all: options build/ezdwm

options:
	@echo "Build options:"
	@echo "CXXFLAGS = $(CXXFLAGS)"
	@echo "LDFLAGS  = $(LDFLAGS)"
	@echo "CXX      = $(CXX)"

build/ezdwm: $(OBJ)
	@mkdir -p build
	@echo "Linking $@"
	$(CXX) $(LDFLAGS) $^ -o $@
	@echo "Finished!"

build/%.o: $(SRC)
	@mkdir -p build
	@echo "Compiling $@"
	$(CXX) $(CXXFLAGS) -c $< -o $@
	@echo "Done."

clean:
	rm -f build/*.o build/ezdwm
	rm -f ezdwm-$(VERSION).tar.gz

dist: clean
	mkdir -p ezdwm-$(VERSION)/src
	cp -R .gitignore ezdwm-$(VERSION)
	cp -R CMakeLists.txt ezdwm-$(VERSION)
	cp -R Makefile ezdwm-$(VERSION)
	cp -R doc ezdwm-$(VERSION)
	cp -R inc ezdwm-$(VERSION)
	cp -R src ezdwm-$(VERSION)
	tar -cf ezdwm-$(VERSION).tar ezdwm-$(VERSION)
	gzip ezdwm-$(VERSION).tar
	rm -rf ezdwm-$(VERSION)

install: all
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp -f build/ezdwm $(DESTDIR)$(PREFIX)/bin
	chmod 755 $(DESTDIR)$(PREFIX)/bin/ezdwm
	mkdir -p $(DESTDIR)$(MANPREFIX)/man1
	sed "s/VERSION/$(VERSION)/g" < ezdwm.1 > $(DESTDIR)$(MANPREFIX)/man1/ezdwm.1
	chmod 644 $(DESTDIR)$(MANPREFIX)/man1/ezdwm.1

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/ezdwm
	rm -f $(DESTDIR)$(MANPREFIX)/man1/ezdwm.1

.PHONY: all options build/%.o build/ezdwm clean dist install uninstall

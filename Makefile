# Define paths
PREFIX = /usr/local
MANPREFIX = $(PREFIX)/share/man

# X11 includes and lib
X11INC = -I/usr/X11R6/include
X11LIB = -lX11

# Xinerama lib and flag
XINERAMAFLAG = -DXINERAMA
XINERAMALIBS  = -lXinerama

# FreeType
FREETYPEINC = -I/usr/include/freetype2
FREETYPELIB = -lfontconfig -lXft

# Project name and version
PROJECT = ezdwm
VERSION = 0.0.1

# Define variables for the version, compiler and flags
CXX = c++
CXXFLAGS = -std=c++20 $(INCS) $(MACROS) $(WARNINGS)
LDFLAGS  = -lstdc++ $(LIBS)

# Warnings and Macros
WARNINGS = -Wall -Wpedantic -Wextra -Wno-deprecated-declarations
MACROS   = -DVERSION=\"$(VERSION)\" -D_DEFAULT_SOURCE $(XINERAMAFLAG)

# Includes and Libs
INCS = $(X11INC) $(FREETYPEINC) -Iinclude/
LIBS = $(X11LIB) $(FREETYPELIB) $(XINERAMALIBS)

# Define the build, source and include directories
BUILD_DIR = build
SRC_DIR = src
INC_DIR = include

# List of C++ source files
SOURCES = $(wildcard $(SRC_DIR)/*.cpp)

# List header files
HEADERS = $(wildcard $(INC_DIR)/*.hpp)

# Locate object files
OBJECTS = $(SOURCES:$(SRC_DIR)/%.cpp=$(BUILD_DIR)/%.o)

# Target binary
TARGET = $(BUILD_DIR)/$(PROJECT)

# Location of the compile_commands.json
COMPILE_COMMANDS = $(BUILD_DIR)/compile_commands.json

all: options $(TARGET) $(COMPILE_COMMANDS)

options:
	@echo "Build options:"
	@echo "CXXFLAGS = $(CXXFLAGS)"
	@echo "LDFLAGS  = $(LDFLAGS)"
	@echo "CXX      = $(CXX)"

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp $(HEADERS)
	@mkdir -p build
	@echo "Compiling $@"
	$(CXX) $(CXXFLAGS) -c $< -o $@
	@echo "Done."

$(TARGET): $(OBJECTS)
	@mkdir -p build
	@echo "Linking $@"
	$(CXX) $(LDFLAGS) $^ -o $@
	@echo "Finished!"

$(COMPILE_COMMANDS): $(SOURCES) $(HEADERS)
	@mkdir -p build
	@touch build/compile_commands.json
	@make -Bn \
	| grep -wE 'gcc|g\+\+|c\+\+' \
	| grep -w '\-c' \
	| sed 's|cd.*.\&\&||g' \
	| jq -nR '[inputs|{directory:".", command:., file: match(" [^ ]+$").string[1:]}]' \
	> $(COMPILE_COMMANDS)

clean:
	rm -f $(OBJECTS) $(TARGET) $(COMPILE_COMMANDS)
	rm -f build/*
	rm -f $(PROJECT)-$(VERSION).tar.gz

distribute: clean
	mkdir -p $(PROJECT)-$(VERSION)/src
	cp -R .gitignore CMakeLists.txt Makefile doc inc src $(PROJECT)-$(VERSION)
	tar -cf $(PROJECT)-$(VERSION).tar $(PROJECT)-$(VERSION)
	gzip $(PROJECT)-$(VERSION).tar
	rm -rf $(PROJECT)-$(VERSION)

install: all
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp -f build/$(PROJECT) $(DESTDIR)$(PREFIX)/bin
	chmod 755 $(DESTDIR)$(PREFIX)/bin/$(PROJECT)
	mkdir -p $(DESTDIR)$(MANPREFIX)/man1
	sed "s/VERSION/$(VERSION)/g" < doc/$(PROJECT).1 > $(DESTDIR)$(MANPREFIX)/man1/$(PROJECT).1
	chmod 644 $(DESTDIR)$(MANPREFIX)/man1/$(PROJECT).1
	# install -Dm 755 $(TARGET) $(DESTDIR)$(PREFIX)/bin/$(TARGET)
	# install -Dm 644 man/man1/$(TARGET).1 $(DESTDIR)$(MANPREFIX)/man1/$(TARGET).1

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/$(PROJECT)
	rm -f $(DESTDIR)$(MANPREFIX)/man1/$(PROJECT).1

.PHONY: all options $(BUILD_DIR)/%.o $(TARGET) $(COMPILE_COMMANDS) clean dist install uninstall

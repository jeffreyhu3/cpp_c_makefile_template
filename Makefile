#
# **************************************************************
# *                Simple C++ Makefile Template                *
# *                                                            *
# * Author: Arash Partow (2003)                                *
# * URL: http://www.partow.net/programming/makefile/index.html *
# *                                                            *
# * Copyright notice:                                          *
# * Free use of this C++ Makefile template is permitted under  *
# * the guidelines and in accordance with the the MIT License  *
# * http://www.opensource.org/licenses/MIT                     *
# *                                                            *
# **************************************************************
#
# Add function generate *.lss, *.map and some print out informats
# Jeffrey Hu, 2019/08/18

CXX      := -c++
OBJDUMP  := objdump

# Optimization level, can be [0, 1, 2, 3, s]. 0 turns off optimization.
# (Note: 3 is not always the best optimization level. See avr-libc FAQ.)
OPT = 0

# List any extra directories to look for include files here.
#     Each directory must be seperated by a space.
#     the root foler is from folder which storage Makefile
#EXTRAINCDIRS =  . src/module1 include
EXTRAINCDIRS = include src

#CXXFLAGS := -pedantic-errors -Wall -Wextra -Werror
CXXFLAGS := -pedantic-errors -Wall -Wextra -O$(OPT) -g\
$(patsubst %,-I%,$(EXTRAINCDIRS))\

LDFLAGS  := -L/usr/lib -lstdc++ -lm
BUILD    := ./build
OBJ_DIR  := $(BUILD)/objects
APP_DIR  := $(BUILD)/apps
TARGET   := program

#list cpp and c format source codes
SRC_CPP  :=                       \
   $(wildcard src/module1/*.cpp) \
   $(wildcard src/module2/*.cpp) \
   $(wildcard src/module3/*.cpp) \
   $(wildcard src/*.cpp)         \
   
SRC_C    := $(wildcard src/*.c) 

OBJECTS := $(SRC_CPP:%.cpp=$(OBJ_DIR)/%.o)
OBJECTS += $(SRC_C:%.c=$(OBJ_DIR)/%.o)

# Define Messages
# English
MSG_COMPILING = Compiling:
MSG_LINKING = Linking:
MSG_EXTENDED_LISTING = Creating Extended Listing:
MSG_CLEANING = Cleaning project:
MSG_SYMBOL_TABLE = Creating Symbol Table/Map file:

all: build $(APP_DIR)/$(TARGET) $(APP_DIR)/$(TARGET).lss $(APP_DIR)/$(TARGET).map

$(OBJ_DIR)/%.o: %.cpp
	@mkdir -p $(@D)
	@echo
	@echo $(MSG_COMPILING) $<
	$(CXX) $(CXXFLAGS)  -o $@ -c $<

$(OBJ_DIR)/%.o: %.c
	@mkdir -p $(@D)
	@echo
	@echo $(MSG_COMPILING) $<
	$(CXX) $(CXXFLAGS) -o $@ -c $<

$(APP_DIR)/$(TARGET): $(OBJECTS)
	@mkdir -p $(@D)
	@echo
	@echo $(MSG_LINKING) $@
	$(CXX) $(CXXFLAGS) $(INCLUDE) $(LDFLAGS) -o $(APP_DIR)/$(TARGET) $(OBJECTS)

$(APP_DIR)/$(TARGET).lss: $(APP_DIR)/$(TARGET)
	@echo
	@echo $(MSG_EXTENDED_LISTING) $@
	$(OBJDUMP) -h -S  $< > $@

$(APP_DIR)/$(TARGET).map: $(APP_DIR)/$(TARGET)
	@echo
	@echo $(MSG_SYMBOL_TABLE) $@
	$(OBJDUMP) -x  $< > $@


.PHONY: all build clean debug release

build:
	@mkdir -p $(APP_DIR)
	@mkdir -p $(OBJ_DIR)

debug: CXXFLAGS += -DDEBUG -g
debug: all

release: CXXFLAGS += -O2
release: all

clean:
	@echo $(MSG_CLEANING)
	-@rm -rvf $(OBJ_DIR)/*
	-@rm -rvf $(APP_DIR)/*
	@echo

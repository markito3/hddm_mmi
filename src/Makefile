OStype = $(shell uname)
ARCHtype = $(shell uname -m)

ifndef OS
OS = $(shell uname)
endif
ifndef ARCH
ARCH = $(shell uname -p)
endif
ifndef OSNAME
OSNAME = $(OS)-$(ARCH)
endif

CPP = c++
LIBXDR = 

ifeq ($(OStype),Linux)
	ifeq ($(ARCHtype),alpha)
		CPP     := c++ -g
	else
		CPP	:= c++ -g -D_REENTRANT
	endif
endif
ifeq ($(OStype),OSF1)
	CPP	:= c++ -g -DBASENAME_USE_BUILTIN
endif
ifeq ($(OStype),Darwin)
	CPP	:= c++ -g -DBASENAME_IN_LIBGEN -DXDR_LONGLONG_MISSING
endif
ifeq ($(OStype),SunOS)
	CPP	:= CC -g -DBASENAME_IN_LIBGEN
	LIBXDR  := -lnsl
endif

OBJDIR = .obj
BINDIR = .bin
BINARIES = $(BINDIR)/xml-hddm $(BINDIR)/hddm-xml $(BINDIR)/hddm-c $(BINDIR)/hddm-cpp $(BINDIR)/hddmcat $(BINDIR)/hddm-py

CXXFLAGS += -I /usr/include/tirpc

INSTALL_PREFIX = ..

HDDM_INCLUDE_FLAGS = -I$(PARTICLETYPE_HOME) \
    -I$(XSTREAM_HOME)/include -I$(XERCESCROOT)/include -I /usr/include/tirpc

all:	mkdirs $(BINARIES)

mkdirs:
	mkdir -p $(OBJDIR) $(BINDIR)

install: xml-xml hddm-schema schema-hddm mkdirs $(BINARIES)
	mkdir -p $(INSTALL_PREFIX)/bin
	cp -v hddm-schema schema-hddm xml-xml $(INSTALL_PREFIX)/bin
	cp -v $(BINARIES) $(INSTALL_PREFIX)/bin

$(BINDIR)/xml-hddm: xml-hddm.cpp $(OBJDIR)/XString.o $(OBJDIR)/XParsers.o $(OBJDIR)/md5.o
	$(CPP) $(LD_FLAGS) \
	$(HDDM_INCLUDE_FLAGS) \
	-o $@ $^ \
	-L$(XSTREAM_HOME)/lib -lxstream \
	-L$(XERCESCROOT)/lib -lxerces-c $(LIBXDR)

$(BINDIR)/hddm-xml: hddm-xml.cpp $(OBJDIR)/XString.o $(OBJDIR)/XParsers.o $(OBJDIR)/md5.o
	$(CPP) $(LD_FLAGS) $(HDDM_INCLUDE_FLAGS) \
	-o $@ $^ \
	-L$(XSTREAM_HOME)/lib -lxstream -lbz2 -lz \
	-L$(XERCESCROOT)/lib -lxerces-c $(LIBXDR)

$(BINDIR)/hddm-c: hddm-c.cpp $(OBJDIR)/XString.o $(OBJDIR)/XParsers.o $(OBJDIR)/md5.o
	$(CPP) $(LD_FLAGS) -I$(XERCESCROOT)/include \
	-o $@ $^ \
	-L$(XERCESCROOT)/lib -lxerces-c $(LIBXDR)

$(BINDIR)/hddm-cpp: hddm-cpp.cpp $(OBJDIR)/XString.o $(OBJDIR)/XParsers.o $(OBJDIR)/md5.o
	$(CPP) $(LD_FLAGS) $(HDDM_INCLUDE_FLAGS) \
	-o $@ $^ \
	-L$(XERCESCROOT)/lib -lxerces-c $(LIBXDR)

$(BINDIR)/hddmcat: hddmcat.cpp
	$(CPP) $(HDDM_INCLUDE_FLAGS) $(LD_FLAGS) -o $@ $^

$(BINDIR)/hddm-py: hddm-py.cpp $(OBJDIR)/XString.o $(OBJDIR)/XParsers.o $(OBJDIR)/md5.o
	$(CPP) $(LD_FLAGS) $(HDDM_INCLUDE_FLAGS) \
	-o $@ $^ \
	-L$(XSTREAM_HOME)/lib -lxstream -lbz2 -lz \
	-L$(XERCESCROOT)/lib -lxerces-c $(LIBXDR)

test: $(BINDIR)/hddm-c $(BINDIR)/hddm-cpp $(BINDIR)/hddm-xml test.xml
	hddm-c test.xml
	hddm-cpp test.xml
	$(CPP) $(LD_FLAGS) -I$(XERCESCROOT)/include \
	-o testhddm \
	testhddm.cpp hddm_v.c hddm_v.cpp -lxstream $(LIBXDR) -lz -lbz2
	./testhddm
	hddm-xml test.hddm

%.xsd: %.xml hddm-schema.xsl
	./hddm-schema $< >$@

$(OBJDIR)/%.o: %.cpp
	$(CPP) $(CXXFLAGS) -I$(XERCESCROOT)/include \
	-c -o $@ $^ 

$(OBJDIR)/%.o: %.c
	$(CPP) $(CXXFLAGS) -I$(XERCESCROOT)/include \
	-c -o $@ $^ 

clean:
	/bin/rm -f $(OBJDIR)/*.o core *.depend

depclean:
	@echo "Nothing to do for make depclean in hddm"

pristine: clean

# end of makefile

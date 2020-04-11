all: make_in_src

make_in_src:
	$(MAKE) -C src

install:
	$(MAKE) -C src install

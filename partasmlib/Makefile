sources=$(wildcard *.py)
sources+=$(wildcard test/*.py)

.res :
	mkdir .res

.res/libs : .res $(wildcard libs/*)
	mkdir -p .res/libs
	cp -rf libs .res/

.res/circuit_test.scad : .res/libs $(sources)
	python test/circuittest.py > $@


# Makefile for motoko  demos

# This works with bash

MOC?=~/motoko/src/moc
STDLIB?=~/motoko/stdlib/src
# we need to specify the output if there is more than one .mo file
OUT=lambda-calculus.wasm

SAMPLES:= test

all:
	$(MOC) --package stdlib $(STDLIB) -wasi-system-api lambda-calculus.mo
	wasmtime lambda-calculus.wasm

clean:
	rm -f $(OUT)

MOC ?= ./moc
PKGS=$(shell vessel sources)
# we need to specify the output if there is more than one .mo file
OUT=lambda-calculus.wasm

all:
	$(MOC) $(PKGS) -wasi-system-api lambda-calculus.mo
	wasmtime $(OUT)

clean:
	rm -f $(OUT)

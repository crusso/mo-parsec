default:
	$(shell vessel bin)/moc $(shell vessel sources) -wasi-system-api -o lambda-calculus.wasm lambda-calculus.mo && wasmtime lambda-calculus.wasm
	rm -f lambda-calculus.wasm

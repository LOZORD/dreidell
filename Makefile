all:
	ghc Main.hs -o run_dreidell
clean:
	rm -v *.o *.hi run_dreidell
run:
	./run_dreidell

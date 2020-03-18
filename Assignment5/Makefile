a.out: y.tab.o lex.yy.o ass5_17CS10057_translator.o
	g++ -g ass5_17CS10057_translator.o lex.yy.o y.tab.o -lfl

lex.yy.c: ass5_17CS10057.l
	flex ass5_17CS10057.l

y.tab.c: ass5_17CS10057.y
	yacc -dtv ass5_17CS10057.y

ass5_17CS10057_translator.o: ass5_17CS10057_translator.cxx
	g++ -g -c ass5_17CS10057_translator.cxx

lex.yy.o: lex.yy.c
	g++ -g -c lex.yy.c

y.tab.o: y.tab.c
	g++ -g -DYYDEBUG -c y.tab.c

clean:
	rm lex.yy.c y.tab.h y.output y.tab.c lex.yy.o y.tab.o ass5_17CS10057_translator.o a.out
	
run:
	./a.out < ass5_17CS10057_test1.c > ass5_17CS10057_quads1.out
	./a.out < ass5_17CS10057_test2.c > ass5_17CS10057_quads2.out
	./a.out < ass5_17CS10057_test3.c > ass5_17CS10057_quads3.out
	./a.out < ass5_17CS10057_test4.c > ass5_17CS10057_quads4.out
	./a.out < ass5_17CS10057_test5.c > ass5_17CS10057_quads5.out

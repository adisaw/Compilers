a.out: lex.yy.o
		gcc lex.yy.o -lfl

lex.yy.o: lex.yy.c
		gcc -c lex.yy.c -lfl

lex.yy.c: ass3_17CS10060.l ass3_17CS10060.c
		flex ass3_17CS10060.l ass3_17CS10060.c

clean:
		rm -f a.out lex.yy.c lex.yy.o

test: 
		./a.out < ass3_17CS10060_test.c

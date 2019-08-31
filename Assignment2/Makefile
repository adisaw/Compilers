a.out: main.o libass2_17CS10060.a
	cc main.o -L. -lass2_17CS10060
main.o: main.c myl.h
	cc -Wall -c main.c
libass2_17CS10060.a : ass2_17CS10060.o
	ar -rcs libass2_17CS10060.a ass2_17CS10060.o
ass2_17CS10060.o: ass2_17CS10060.c myl.h
	cc -Wall -c ass2_17CS10060.c
clean:
	rm a.out main.o libass2_17CS10060.a ass2_17CS10060.o 

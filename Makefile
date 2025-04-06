all: echo

parser.c parser.h: parser.y
	bison -d -o parser.c parser.y

lexer.c: lexer.l parser.h
	flex -o lexer.c lexer.l

echo: lexer.o parser.o main.o
	$(CC) -o echo lexer.o parser.o main.o

lexer.o: lexer.c
	$(CC) -c lexer.c

parser.o: parser.c
	$(CC) -c parser.c

main.o: main.c
	$(CC) -c main.c

clean:
	rm -f parser.c parser.h lexer.c *.o echo


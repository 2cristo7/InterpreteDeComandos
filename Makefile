CC = gcc
CFLAGS = -Wall -g
OBJS = lexer.o parser.o main.o symbolTable.o hashTable.o
TARGET = interpreter

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJS) -lm

lexer.c: lexer.l parser.h
	flex -o lexer.c lexer.l

parser.c parser.h: parser.y
	bison -d -o parser.c parser.y

lexer.o: lexer.c
	$(CC) $(CFLAGS) -c lexer.c

parser.o: parser.c
	$(CC) $(CFLAGS) -c parser.c

main.o: main.c
	$(CC) $(CFLAGS) -c main.c

symbolTable.o: symbolTable.c symbolTable.h
	$(CC) $(CFLAGS) -c symbolTable.c

hashTable.o: hashTable.c hashTable.h definitions.h
	$(CC) $(CFLAGS) -c hashTable.c

# Ejecución normal
run: $(TARGET)
	./$(TARGET)

# Ejecución con Valgrind
valgrind: $(TARGET)
	valgrind --leak-check=full --track-origins=yes ./$(TARGET)

clean:
	rm -f *.o lexer.c parser.c parser.h $(TARGET)

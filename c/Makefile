CFLAGS=--std=c99 -Wall -g

FILES=dyn_buffer lexer lexeme utf8
FILES_O=$(addsuffix .o,$(FILES))

TARGET=tdb

%.o: %.c %.h
	$(CC) $(CFLAGS) -c -o $@ $<

$(TARGET): $(FILES_O) main.c
	$(CC) $(CFLAGS) -o $@ $^

clean:
	rm -f $(FILES_O) $(TARGET)

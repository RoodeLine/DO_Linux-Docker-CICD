name = s21_grep
CC = gcc
FLAGS = -Wall -Werror -Wextra

all: s21_grep

rebuild: clean check s21_grep

s21_grep:
	$(CC) $(FLAGS) $(name).c -o $(name)

clean:
	rm $(name)

check:
	clang-format --style=Google -n *.c *.h

test:
	bash test.sh
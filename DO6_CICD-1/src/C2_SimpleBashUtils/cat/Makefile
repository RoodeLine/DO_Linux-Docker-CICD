name = s21_cat
CC = gcc
FLAGS = -Wall -Werror -Wextra

all: s21_cat

rebuild: clean check s21_cat

s21_cat:
	$(CC) $(FLAGS) $(name).c -o $(name)

clean:
	rm $(name)

check:
	clang-format --style=Google -n *.c *.h

test:
	bash test.sh
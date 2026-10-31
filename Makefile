
CC = gcc
CFLAGS = -std=c11 -Wall -Wextra -Wpedantic -g -DMAT_TEST_ALLOC

EX1 = test_ex1.c matrice.c matrice_alloc.c
EX2 = test_ex2.c matrice.c matrice_alloc.c matrice_io.c
EX3 = test_ex3.c matrice.c matrice_alloc.c matrice_calcul.c
EX4 = main.c matrice.c matrice_alloc.c matrice_io.c matrice_calcul.c

all: test_ex1 test_ex2 test_ex3 demo_matrices

test_ex1: $(EX1)
	$(CC) $(CFLAGS) $(EX1) -o test_ex1

test_ex2: $(EX2)
	$(CC) $(CFLAGS) $(EX2) -o test_ex2

test_ex3: $(EX3)
	$(CC) $(CFLAGS) $(EX3) -o test_ex3

demo_matrices: $(EX4)
	$(CC) $(CFLAGS) $(EX4) -o demo_matrices

clean:
	rm -f test_ex1 test_ex2 test_ex3 demo_matrices

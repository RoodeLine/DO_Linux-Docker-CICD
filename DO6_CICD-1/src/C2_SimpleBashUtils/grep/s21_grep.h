#ifndef DESKTOP_S21_GREP_H
#define DESKTOP_S21_GREP_H

#include <getopt.h>
#include <regex.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>

typedef struct {
  int e;
  int i;
  int v;
  int c;
  int l;
  int n;
  int h;
  int s;
  int f;
  int o;
} Flags_g;

typedef struct {
  char name[255];
  int lines;
  int relevant_lines;
} File_g;

typedef struct {
  char *line;
  size_t size;
  int count;
} Pattern_g;

void print_err(int);
int regex_exec(regex_t *, char *);
void print_line(Flags_g, File_g, int, const char *);
int regex_mat(regex_t *, Flags_g, File_g, int, char *);
int reg_cp(regex_t *, Flags_g, Pattern_g);
int pat_file(Pattern_g *, const char *);
int flag_set(Flags_g *, Pattern_g *, int, char *);
int pars(Flags_g *, Pattern_g *, int, char **);

int file_init(File_g *, const char *);
int file_read(File_g, Flags_g, regex_t *, int);
int str_search(const char *, Flags_g, regex_t *);
void print_line(Flags_g, File_g, int, const char *);

int Pattern_init(Pattern_g *);
int Pattern_add(Pattern_g *, char *);
void Pattern_delete(Pattern_g *);

#endif

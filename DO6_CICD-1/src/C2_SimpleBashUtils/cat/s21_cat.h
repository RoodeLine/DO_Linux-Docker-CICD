#ifndef DESKTOP_S21_CAT_H
#define DESKTOP_S21_CAT_H

#include <getopt.h>
#include <stdio.h>

typedef struct {
  int b_number_non_blank;
  int n_number_all;
  int s_squeeze_blank;
  int e_display_end_of_line;
  int t_display_tab;
  int v_display_non_print;
} Flags;

Flags read_flags(int argc, char *argv[]);
void check_file(Flags flags, char *name_file);
void func_b(int ch, int *count, int flag);
void func_t(int *ch, int flag);
void func_e(int ch, int flag);
void func_n(int ch, int *count, int flag);
void func_v(int *ch, int flag);

#endif  // DESKTOP_S21_CAT_H

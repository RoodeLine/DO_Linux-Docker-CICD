#include "s21_cat.h"

int main(int argc, char *argv[]) {
  Flags flags = read_flags(argc, argv);
  check_file(flags, argv[argc - 1]);
  return 0;
}

Flags read_flags(int argc, char *argv[]) {
  struct option long_option[] = {{"number-nonblank", 0, 0, 'b'},
                                 {"number", 0, 0, 'n'},
                                 {"squeeze-blank", 0, 0, 's'},
                                 {"show-ends", 0, 0, 'E'},
                                 {"show-tabs", 0, 0, 'T'},
                                 {"show-nonprinting", 0, 0, 'v'},
                                 {0, 0, 0, 0}};

  int current_flag = getopt_long(argc, argv, "bnseEtTv", long_option, NULL);
  Flags flags = {0, 0, 0, 0, 0, 0};
  for (; current_flag != -1;
       current_flag = getopt_long(argc, argv, "bnseEtTv", long_option, NULL)) {
    if (current_flag == '?') {
      fprintf(stderr, "Unknown option: %s\n", optarg);
      continue;
    }
    switch (current_flag) {
      case 'b':
        flags.b_number_non_blank = 1;
        break;
      case 'n':
        flags.n_number_all = 1;
        break;
      case 's':
        flags.s_squeeze_blank = 1;
        break;
      case 'e':
        flags.e_display_end_of_line = 1;
        flags.v_display_non_print = 1;
        break;
      case 'v':
        flags.v_display_non_print = 1;
        break;
      case 'E':
        flags.e_display_end_of_line = 1;
        break;
      case 't':
        flags.t_display_tab = 1;
        flags.v_display_non_print = 1;
        break;
      case 'T':
        flags.t_display_tab = 1;
        break;
      default:
        break;
    }
  }
  if (flags.n_number_all && flags.b_number_non_blank) flags.n_number_all = 0;
  return flags;
}

void check_file(Flags flags, char *name_file) {
  FILE *file = fopen(name_file, "r");
  if (file != NULL) {
    int count = 0;
    int emp = 0;
    char str_end = '\0';
    while (!feof(file) && !ferror(file)) {
      int ch = getc(file);
      if (ch != EOF) {
        if (ch == '\n' && str_end == '\n' && flags.s_squeeze_blank) {
          emp++;
        } else
          emp = 0;
        if (emp <= 1 && (str_end == '\0' || str_end == '\n')) {
          func_n(ch, &count, flags.n_number_all);
          func_b(ch, &count, flags.b_number_non_blank);
        }
        if (emp <= 1) {
          func_t(&ch, flags.t_display_tab);
          func_e(ch, flags.e_display_end_of_line);
          func_v(&ch, flags.v_display_non_print);
          putchar(ch);
          str_end = (char)ch;
        }
      }
    }
    fclose(file);
  } else {
    fprintf(stderr, "cat: %s: No such file or directory\n", name_file);
  }
}

void func_e(int ch, int flag) {
  if (flag && ch == '\n') putchar('$');
}

void func_v(int *ch, int flag) {
  if (flag &&
      ((*ch >= 0 && *ch <= 8) || (*ch >= 11 && *ch <= 31) || *ch == 127)) {
    putchar('^');
    if (*ch >= 127)
      *ch -= 64;
    else
      *ch += 64;
  }
}

void func_b(int ch, int *count, int flag) {
  if (flag && (ch != '\0') && (ch != '\n')) {
    *count += 1;
    printf("%6d\t", *count);
  }
}

void func_n(int ch, int *count, int flag) {
  if (flag && (ch != '\0')) {
    *count += 1;
    printf("%6d\t", *count);
  }
}

void func_t(int *ch, int flag) {
  if (flag && *ch == '\t') {
    putchar('^');
    *ch = 'I';
  }
}

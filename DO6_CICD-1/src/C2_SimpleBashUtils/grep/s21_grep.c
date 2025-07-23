#define _GNU_SOURCE  //Нужно для запуска на LINUX
#include "s21_grep.h"

int main(int argc, char *argv[]) {
  Flags_g flags = {0};
  Pattern_g pat;
  Pattern_init(&pat);
  regex_t regex;
  if (pars(&flags, &pat, argc, argv)) {
    if ((pat.count == 0) && (optind < argc)) Pattern_add(&pat, argv[optind++]);
    if (reg_cp(&regex, flags, pat)) {
      int files = argc - optind;
      while (optind < argc) {
        File_g file;
        file_init(&file, argv[optind++]);
        file_read(file, flags, &regex, files);
      }
      regfree(&regex);
    }
  }
  Pattern_delete(&pat);
  return 0;
}

int pars(Flags_g *flags, Pattern_g *pat, int argc, char *argv[]) {
  int err = 0, n = 0;
  while (((n = getopt(argc, argv, "e:ivclnhf:o")) != -1) && (!err)) {
    err = flag_set(flags, pat, n, optarg);
  }
  return !err;
}

int flag_set(Flags_g *flags, Pattern_g *pat, int n, char *ch) {
  int err = 0;
  if (n == 'e') {
    flags->e = 1;
    Pattern_add(pat, ch);
  } else if (n == 'i') {
    flags->i = 1;
  } else if (n == 'v') {
    flags->v = 1;
  } else if (n == 'c') {
    flags->c = 1;
  } else if (n == 'l') {
    flags->l = 1;
  } else if (n == 'n') {
    flags->n = 1;
  } else if (n == 'h') {
    flags->h = 1;
  } else if (n == 's') {
    flags->s = 1;
  } else if (n == 'f') {
    flags->f = 1;
    if (!pat_file(pat, ch)) {
      err = 1;
      if (!flags->s)
        fprintf(stderr, "s21_grep: %s: No such file or directory\n", ch);
    }
  } else if (n == 'o') {
    flags->o = 1;
  } else {
    err = 1;
    fprintf(stderr, "s21_grep: Invalid key - \"%c\"\n", n);
  }
  return err;
}

int pat_file(Pattern_g *pat, const char *name) {
  int err = 0;
  char *line = NULL;
  size_t len = 0;
  FILE *file = fopen(name, "r");
  if (file != NULL) {
    while (getline(&line, &len, file) != -1) {
      if (line != NULL) {
        if (line[strlen(line) - 1] == '\n') line[strlen(line) - 1] = '\0';
        Pattern_add(pat, line);
      }
    }
    fclose(file);
  } else
    err = 1;
  if (line != NULL) free(line);
  return !err;
}

int reg_cp(regex_t *regex, Flags_g flags, Pattern_g pat) {
  int err_cp = regcomp(regex, pat.line,
                       REG_NEWLINE | ((flags.e || flags.f) ? REG_EXTENDED : 0) |
                           ((flags.i) ? REG_ICASE : 0));
  if (err_cp) print_err(err_cp);
  return !err_cp;
}

int file_init(File_g *file, const char *name) {
  int err = 0;
  if (strlen(name) <= 255) {
    strcpy(file->name, name);
    file->lines = 0;
    file->relevant_lines = 0;
  } else
    err = 1;
  return !err;
}

int file_read(File_g file, Flags_g flags, regex_t *regex, int files) {
  char *line = NULL;
  int flag_while = 0;
  size_t length = 0;
  FILE *fileq = fopen(file.name, "r");
  if (fileq != NULL) {
    flag_while = 1;
  } else {
    if (!flags.s)
      fprintf(stderr, "s21_grep: %s: No such file or directory\n", file.name);
  }
  while (flag_while == 1 && (getline(&line, &length, fileq) != -1)) {
    if (line != NULL) {
      file.lines++;
      if ((regex_exec(regex, line) && !flags.v) ||
          (!regex_exec(regex, line) && flags.v)) {
        file.relevant_lines++;
        if (!flags.c && !flags.l && flags.o)
          regex_mat(regex, flags, file, files, line);
        else if (!flags.c && !flags.l && !flags.o)
          print_line(flags, file, files, line);
      }
    }
  }
  if (flags.l && file.relevant_lines) printf("%s\n", file.name);
  if (!flags.l && flags.c) {
    if (!flags.h && files > 1) printf("%s:", file.name);
    printf("%d\n", file.relevant_lines);
  }
  fclose(fileq);
  if (line != NULL) free(line);
  return 0;
}

int regex_mat(regex_t *regex, Flags_g flags, File_g file, int files,
              char *str) {
  size_t n = 1;
  regmatch_t x[1];
  int err = 0;
  err = regexec(regex, str, n, x, 0);
  if (err)
    print_err(err);
  else {
    char *res;
    int res_l = x[0].rm_eo - x[0].rm_so;
    res = (char *)malloc((res_l + 1) * (sizeof(char)));
    strncpy(res, &str[x[0].rm_so], res_l);
    res[res_l] = '\0';
    print_line(flags, file, files, res);
    free(res);
    if ((long unsigned int)x[0].rm_so + res_l < strlen(str))
      regex_mat(regex, flags, file, files, &str[x[0].rm_eo]);
  }
  return !err;
}

void print_line(Flags_g flags, File_g file, int files, const char *str) {
  if (!flags.h && files > 1) printf("%s:", file.name);
  if (flags.n) printf("%d:", file.lines);
  printf("%s", str);
  if ((str[strlen(str) - 1] != '\n')) printf("%c", '\n');
}

int regex_exec(regex_t *regex, char *str) {
  int err = 1;
  size_t n = 1;
  regmatch_t x[1];
  err = regexec(regex, str, n, x, 0);
  if (err) print_err(err);
  return !err;
}

int Pattern_init(Pattern_g *patterns) {
  int err = 0;
  patterns->line = calloc(1, sizeof(char));
  if (patterns->line != NULL) {
    strcpy(patterns->line, "\0");
    patterns->count = 0;
    patterns->size = 0;
  } else {
    err = 1;
  }
  return !err;
}

int Pattern_add(Pattern_g *patterns, char *str) {
  int err = 0;
  if (patterns->count == 0) {
    patterns->line = realloc(patterns->line, (strlen(str) + 1) * sizeof(char));
    if (patterns->line != NULL)
      strcpy(patterns->line, str);
    else
      err = 1;

  } else {
    patterns->line = realloc(patterns->line,
                             (patterns->size + strlen(str) + 1) * sizeof(char));
    if (patterns->line != NULL) {
      strcat(patterns->line, "|");
      strcat(patterns->line, str);
    } else
      err = 1;
  }
  if (!err) {
    patterns->count++;
    patterns->size = strlen(patterns->line) + 1;
  }
  return !err;
}

void Pattern_delete(Pattern_g *patterns) {
  if (patterns->line != NULL) free(patterns->line);
  patterns->count = 0;
  patterns->size = 0;
}

void print_err(int err) {
  if (err == REG_BADPAT)
    fprintf(stderr, "Regex: Invalid regular expression\n");
  else if (err == REG_ECOLLATE)
    fprintf(stderr, "Regex: Invalid collating element referenced\n");
  else if (err == REG_ECTYPE)
    fprintf(stderr, "Regex: Invalid character class type referenced\n");
  else if (err == REG_EESCAPE)
    fprintf(stderr, "Regex: Trailing \\ in pattern\n");
  else if (err == REG_ESUBREG)
    fprintf(stderr, "Regex: Number in \"\\digit\" invalid or in error\n");
  else if (err == REG_EBRACK)
    fprintf(stderr, "Regex: \"[]\" imbalance\n");
  else if (err == REG_EPAREN)
    fprintf(stderr, "Regex: \"\\(\\)\" or \"()\" imbalance\n");
  else if (err == REG_EBRACE)
    fprintf(stderr, "Regex: \"\\{\\}\" imbalance\n");
  else if (err == REG_BADBR)
    fprintf(stderr,
            "Regex: Content of \"\\{\\}\" invalid: not a number, number too "
            "large, more than two numbers, first larger than second\n");
  else if (err == REG_ERANGE)
    fprintf(stderr, "Regex: Invalid endpoint in range expression\n");
  else if (err == REG_ESPACE)
    fprintf(stderr, "Regex: Out of memory\n");
  else if (err == REG_BADRPT)
    fprintf(
        stderr,
        "Regex: '?' , '*' , or '+' not preceded by valid regular expression\n");
}
#!/bin/bash

COUNTER=0
FAIL=0
COMPLETE=0
LOG1="log_test_s21_cat.log"
LOG2="log_test_cat.log"
SOURCE="test.txt"

test_exec()
{
  # Запись результатов в отдельные файлы
  ./s21_cat $@ $SOURCE > $LOG1
	cat $@ $SOURCE > $LOG2
  # Сравнене результатов и вывод их на экран
  DIFFERENCE="$(diff -s $LOG1 $LOG2)"
  (( COUNTER++ ))
  if [ "$DIFFERENCE" == "Files $LOG1 and $LOG2 are identical" ] ||
     [ "$DIFFERENCE" == "Файлы $LOG1 и $LOG2 идентичны" ]
  then
    (( COMPLETE++ ))
      echo -e "$COUNTER|\033[31m$FAIL\033[0m|\033[32m$COMPLETE > \033[32mCOMPLETE\033[0m cat $@ $SOURCE"
  else
    (( FAIL++ ))
      echo -e "$COUNTER|\033[31m$FAIL\033[0m|\033[32m$COMPLETE > \033[31mFAIL\033[0m cat $@ $SOURCE"
  fi
  # Удаление файлов с результатами
  rm $LOG1 $LOG2
}

# Тест с одним флагом
for flag1 in b e n s t
do
  flags="-$flag1"
	test_exec $flags
done

# Тест с двумя флагами
for flag1 in b e n s t
do
  for flag2 in b e n s t
  do
    if [ $flag1 != $flag2 ]
      then
        flags="-$flag1 -$flag2"
        test_exec $flags
    fi
  done
done

# Тест с тремя флагами
for flag1 in b e n s t
do
  for flag2 in b e n s t
  do
    for flag3 in b e n s t
    do
      if [ $flag1 != $flag2 ] \
      && [ $flag1 != $flag3 ] \
      && [ $flag2 != $flag3 ]
        then
          flags="-$flag1 -$flag2 -$flag3"
          test_exec $flags
      fi
    done
  done
done

# Тест с четырьмя флагами
for flag1 in b e n s t
do
  for flag2 in b e n s t
  do
    for flag3 in b e n s t
    do
      for flag4 in b e n s t
      do
        if [ $flag1 != $flag2 ] \
        && [ $flag1 != $flag3 ] \
        && [ $flag1 != $flag4 ] \
        && [ $flag2 != $flag3 ] \
        && [ $flag2 != $flag4 ] \
        && [ $flag3 != $flag4 ]
          then
            flags="-$flag1 -$flag2 -$flag3 -$flag4"
            test_exec $flags
        fi
      done
    done
  done
done

# Тест с пятью флагами
flags="-b -e -n -s -t"
test_exec $flags

echo -e "\033[93m-------FINAL SCORE-------"
echo -e "\033[0mTests:     $COUNTER"
echo -e "\033[31mFailed:    $FAIL"
echo -e "\033[32mCompleted: $COMPLETE\033[0m"


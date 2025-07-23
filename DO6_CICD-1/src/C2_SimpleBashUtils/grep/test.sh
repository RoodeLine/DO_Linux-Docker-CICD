#!/bin/bash

COUNTER=0
FAIL=0
COMPLETE=0
LOG1="log_test_s21_grep.log"
LOG2="log_test_grep.log"
SOURCE1="test_sample_text1.txt"
SOURCE2="test_sample_text2.txt"
SOURCE3="test_sample_text3.txt"
PATTERNS="test_patterns_text.txt"

declare -a SPELLS=(
  "moon $SOURCE1"
  "-e moon -e shadow $SOURCE1"
  "-f $PATTERNS $SOURCE2"
  "-e "for" -f $PATTERNS $SOURCE2 $SOURCE3"
)

test_exec()
{
  for i in ${!SPELLS[@]}
  do
    # Запись результатов в отдельные файлы
    ./s21_grep $@ ${SPELLS[$i]} > $LOG1
    grep $@ ${SPELLS[$i]} > $LOG2
    # Сравнене результатов и вывод их на экран
    DIFFERENCE="$(diff -s $LOG1 $LOG2)"
    (( COUNTER++ ))
    if [ "$DIFFERENCE" == "Files $LOG1 and $LOG2 are identical" ] ||
      [ "$DIFFERENCE" == "Файлы $LOG1 и $LOG2 идентичны" ]
    then
      (( COMPLETE++ ))
        echo -e "$COUNTER|\033[31m$FAIL\033[0m|\033[32m$COMPLETE > \033[32mCOMPLETE\033[0m grep $@ ${SPELLS[$i]}"
    else
      (( FAIL++ ))
        echo -e "$COUNTER|\033[31m$FAIL\033[0m|\033[32m$COMPLETE > \033[31mFAIL\033[0m grep $@ ${SPELLS[$i]}"
    fi
    # Удаление файлов с результатами
    rm $LOG1 $LOG2
  done
}

# Тест с одним флагом
for flag1 in i v c l n h o
do
  flags="-$flag1"
  test_exec $flags
done

# Тест с двумя флагами
for flag1 in i v c l n h o
do
  for flag2 in i v c l n h o
  do
    if [ $flag1 != $flag2 ]
      then
        flags="-$flag1 -$flag2"
        test_exec $flags
    fi
  done
done

# Тест с тремя флагами
for flag1 in i v c l n h o
do
  for flag2 in i v c l n h o
  do
    for flag3 in i v c l n h o
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

# Тест с семью флагами
flags="-i -v -c -l -n -h -o"
test_exec $flags

echo -e "\033[93m-------FINAL SCORE-------"
echo -e "\033[0mTests:     $COUNTER"
echo -e "\033[31mFailed:    $FAIL"
echo -e "\033[32mCompleted: $COMPLETE\033[0m"
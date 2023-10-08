#!/bin/bash -e

# ファイルを作成する
FILES=$(cat _file_creation.txt)

for F in $FILES; do
  echo "creating ... ${F}"
  touch ${HOME}/${F}
done


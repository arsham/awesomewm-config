#!/bin/zsh

patching=( lain )

for name in "${patching[@]}"; do
  pushd $name
    git restore .
  popd
done

git submodule update --remote --recursive

for name in "${patching[@]}"; do
    echo "Patching $name:"
    pushd $name
    for file in ../patches/$name/*; do
      git apply $file
      echo "... Patched" $(basename $file)
    done
  popd
done

commit=$(git describe --always --dirty --match 'NOT A TAG')
if [ $? != 0 ]
then
  if [ -f version.h ]
  then
    exit 0
  else
    commit="Uknown version (not in a git repository)"
  fi
fi

echo "static char const *const git_commit = \"$commit\";" > version.h.tmp;

# Only modify version.h if the version has changed. This avoid useless
# re-compilation
if diff -q version.h.tmp version.h >/dev/null 2>&1;
then
  rm version.h.tmp;
else
  mv version.h.tmp version.h;
fi

commit=$(git describe --always --dirty --match 'NOT A TAG')

echo "static char const *const git_commit = \"$commit\";" > version.h.tmp;

# Only modify version.cpp if the version has changed. This avoid useless
# re-compilation
if diff -q version.h.tmp version.h >/dev/null 2>&1;
then
  rm version.h.tmp;
else
  mv version.h.tmp version.h;
fi

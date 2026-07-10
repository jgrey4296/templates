# Make sure the locale variables are set to valid values.
echo "- Fixing locale variables"
eval $(/usr/bin/locale-check C.UTF-8)

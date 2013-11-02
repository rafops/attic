```
brew install aspell
```

```
preunzip *.wl
```

Then merge into a single list, eliminating duplicates:

```
sort --unique --ignore-case *.wl >list.txt
```

In additon, I want everything to be UTF-8:

```
iconv -f ISO8859-1 -t UTF-8 list.txt >ulist.txt
```

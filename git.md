Git
===

## Change Author Email

```
git clone --bare git@github.com:account/repository.git
```

```
cd repository.git
```

```
#!/bin/sh

git filter-branch --env-filter '

OLD_EMAIL="someone@oldemail.com"
CORRECT_NAME="John Doe"
CORRECT_EMAIL="someone@newemail.com"

if [ "$GIT_COMMITTER_EMAIL" = "$OLD_EMAIL" ]
then
    export GIT_COMMITTER_NAME="$CORRECT_NAME"
    export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"
fi
if [ "$GIT_AUTHOR_EMAIL" = "$OLD_EMAIL" ]
then
    export GIT_AUTHOR_NAME="$CORRECT_NAME"
    export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"
fi
' --tag-name-filter cat -- --branches --tags
```

```
git push --force --tags origin 'refs/heads/*'
```

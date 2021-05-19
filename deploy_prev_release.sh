#!/bin/bash

# For use in Docker - set git credentials from environment
#set git credentials
if [ -n "$GIT_USER" ] && [ -n "$GIT_PASSWORD" ]; then
    echo "Setting git user and password"
    git config --global credential.helper '!f() { sleep 1; echo "username=${GIT_USER}"; echo "password=${GIT_PASSWORD}"; }; f'
else
    echo "NOT setting git user and password"
fi
#set git email
if [ -n "$GIT_EMAIL" ]; then
    git config --global user.email "$GIT_EMAIL"
fi
if [ -n "$GIT_NAME" ]; then
  git config --global user.name "$GIT_NAME"
fi

#Get tag
GIT_URL=`git remote show origin | awk '/Push  URL/ { print $NF }'`
TAG=$1
if [ -z "$TAG" ]; then
    echo "You must specify a tag to build"
    exit 1
fi

#checkout tag
TAG_DIR=$(mktemp -d /tmp/tag.XXXXXX)
cd $TAG_DIR

git clone $GIT_URL .
if [ $? -ne 0 ]; then
    echo "ERROR: Unable to clone $GIT_URL"
    rm -rf $TAG_DIR
    exit 1
fi

git checkout tags/$TAG
if [ $? -ne 0 ]; then
    echo "ERROR: Unable to checkout tag $TAG"
    rm -rf $TAG_DIR
    exit 1
fi

#build html
make clean html
if [ $? -ne 0 ]; then
    echo "ERROR: Unable to build html files"
    rm -rf $TAG_DIR
    exit 1
fi

#checkout gh-pages
GH_PAGES_DIR=$(mktemp -d /tmp/ghpages.XXXXXX)
cd $GH_PAGES_DIR

git clone $GIT_URL .
if [ $? -ne 0 ]; then
    echo "ERROR: Unable to clone $GIT_URL"
    rm -rf $GH_PAGES_DIR
    exit 1
fi

git checkout gh-pages
if [ $? -ne 0 ]; then
    echo "ERROR: Unable to checkout gh-pages"
    rm -rf $GH_PAGES_DIR
    exit 1
fi

#copy over html and commit
git rm -rf previous_releases/$TAG 2> /dev/null
mkdir -p previous_releases/$TAG
cp -r $TAG_DIR/_build/html/* previous_releases/$TAG/
git add previous_releases

git commit -m "Adding previous release $TAG"
if [ $? -ne 0 ]; then
    echo "ERROR: Unable to commit changes to gh-pages"
    rm -rf $GH_PAGES_DIR $TAG_DIR
    exit 1
fi

git push
if [ $? -ne 0 ]; then
    echo "ERROR: Unable to push changes to gh-pages"
    rm -rf $GH_PAGES_DIR $TAG_DIR
    exit 1
fi

echo "Success"

#clean-up 
rm -rf $GH_PAGES_DIR $TAG_DIR

#!/bin/bash

#Get branch
GIT_URL=`git remote show origin | awk '/Push  URL/ { print $NF }'`
BRANCH=$1
if [ -z "$BRANCH" ]; then
    echo "You must specify a branch to build"
    exit 1
fi

#checkout branch
BRANCH_DIR=$(mktemp -d /tmp/branch.XXXX)
cd $BRANCH_DIR

git clone $GIT_URL .
if [ $? -ne 0 ]; then
    echo "ERROR: Unable to clone $GIT_URL"
    rm -rf $BRANCH_DIR
    exit 1
fi

git checkout $BRANCH
if [ $? -ne 0 ]; then
    echo "ERROR: Unable to checkout branch $BRANCH"
    rm -rf $BRANCH_DIR
    exit 1
fi

#build html
make clean html
if [ $? -ne 0 ]; then
    echo "ERROR: Unable to build html files"
    rm -rf $BRANCH_DIR
    exit 1
fi

#checkout gh-pages
GH_PAGES_DIR=$(mktemp -d /tmp/ghpages.XXXX)
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
git rm -rf release_candidates/$BRANCH 2> /dev/null
mkdir -p release_candidates/$BRANCH
cp -r $BRANCH_DIR/_build/html/* release_candidates/$BRANCH/
git add release_candidates

git commit -m "Adding release candidate $BRANCH"
if [ $? -ne 0 ]; then
    echo "ERROR: Unable to commit changes to gh-pages"
    rm -rf $GH_PAGES_DIR $BRANCH_DIR
    exit 1
fi

git push
if [ $? -ne 0 ]; then
    echo "ERROR: Unable to push changes to gh-pages"
    rm -rf $GH_PAGES_DIR $BRANCH_DIR
    exit 1
fi

echo "Success"

#clean-up 
rm -rf $GH_PAGES_DIR $BRANCH_DIR

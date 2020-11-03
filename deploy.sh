#!/bin/sh

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

GIT_URL=`git config --get remote.origin.url`
DEPLOY_DIR=/tmp/deploy.$$
mkdir ${DEPLOY_DIR}
(cd ${DEPLOY_DIR} ; \
    git clone ${GIT_URL} . \
 && git checkout gh-pages \
 && git rm -rf *.html _* objects.inv searchindex.js
)
cp -r _build/html/* ${DEPLOY_DIR}
touch ${DEPLOY_DIR}/.nojekyll
echo "docs.perfsonar.net" > ${DEPLOY_DIR}/CNAME
(cd ${DEPLOY_DIR} ; \
    git add .nojekyll *  \
    && git commit -m "deploy"  \
    && git push)

rm -rf ${DEPLOY_DIR}

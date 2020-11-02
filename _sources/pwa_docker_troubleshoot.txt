Troubleshooting Docker Containers
==================================

Use the ``docker ps`` command to list the running containers.

You should see all 5-6 containers running (again, ``postfix`` is optional).

.. code-block:: shell

    # docker ps
    CONTAINER ID        IMAGE                  COMMAND                  CREATED             STATUS              PORTS                                                              NAMES
    2dd0cd671538        perfsonar/pwa-admin    "/start.sh"              2 weeks ago         Up 2 weeks          80/tcp, 8080/tcp                                                   pwa-admin1
    f2227dd2ee2a        perfsonar/pwa-pub      "node /app/api/pwapub"   2 weeks ago         Up 2 weeks          8080/tcp                                                           pwa-pub1
    36179bd10524        perfsonar/sca-auth     "/app/docker/start.sh"   2 weeks ago         Up 2 weeks          80/tcp, 8080/tcp                                                   sca-auth
    c10b07ae72cc        nginx                  "nginx -g 'daemon off"   3 weeks ago         Up 5 days           0.0.0.0:80->80/tcp, 0.0.0.0:443->443/tcp, 0.0.0.0:9443->9443/tcp   nginx
    727dc2f5e528        mongo                  "docker-entrypoint.sh"   8 months ago        Up 4 weeks          27017/tcp                                                          mongo
    0c03b689c722        yorkshirekev/postfix   "/startservices.sh mc"   3 weeks ago         Up 3 weeks          0.0.0.0:587->25/tcp                                                postfix

Note: sometimes, docker containers will initially not have connectivity to the outside world. Usually this can be resolved by running ``systemctl restart docker``. If you are experiencing this issue, make sure your firewall rules are not being overridden by config management software (puppet, ansible, etc).


Note: sometimes, docker containers will initially not have connectivity to the outside world. Usually this can be resolved by running ``systemctl restart docker``. If you are experiencing this issue, make sure your firewall rules are not being overridden by config management software (puppet, ansible, etc).


Troubleshooting Containers
---------------------------

Use the ``docker logs`` command to see logs for a container. Adjust ``--tail`` to change how many logs are displayed. Add the ``-f`` flag to watch the logs as new records come in (like ``tail``)

.. code-block:: shell

    # docker logs pwa-admin1 --tail 10
    1|pwaadmin       | Tue Feb 12 2019 21:41:43 GMT+0000 (UTC) - info: HTTP POST /health/pwacache statusCode=200, url=/health/pwacache, host=0.0.0.0:8080, accept=application/json, content-type=application/json, content-length=14, connection=close, method=POST, httpVersion=1.1, originalUrl=/health/pwacache, , responseTime=1
    2|pwacache       | Tue Feb 12 2019 21:42:43 GMT+0000 (UTC) - info: Host found in hostgroup; not expiring  5b05d426f895e94f17bef826 em-4.of-proxy.newy32aoa.net.internet2.edu
    2|pwacache       | Tue Feb 12 2019 21:42:43 GMT+0000 (UTC) - info: Host found in hostgroup; not expiring  5b05d42af895e94f17bf0216 perfsonar.cbio.uct.ac.za
    2|pwacache       | Tue Feb 12 2019 21:42:43 GMT+0000 (UTC) - info: All hosts have been processed successfully
    2|pwacache       | Tue Feb 12 2019 21:42:43 GMT+0000 (UTC) - info: successfully deleted hosts
    2|pwacache       | Tue Feb 12 2019 21:42:43 GMT+0000 (UTC) - info: processing datasource for expiration/duplication prevention:gls ................................................................................
    2|pwacache       | Tue Feb 12 2019 21:42:43 GMT+0000 (UTC) - info: lookup service label=GLS, type=global-sls, activehosts_url=http://ps1.es.net:8096/lookup/activehosts.json, query=?type=service, url=http://35.237.255.214:8090/lookup/records?type=service
    2|pwacache       | Tue Feb 12 2019 21:42:43 GMT+0000 (UTC) - info: num result 2543
    2|pwacache       | Tue Feb 12 2019 21:42:47 GMT+0000 (UTC) - info: done expiring/updating LS URLs for db hosts
    3|ui             | [Tue Feb 12 2019 21:51:56 GMT+0000 (UTC)] "GET /" "undefined"

Interacting with containers
----------------------------

You can enter an interactive ``bash`` shell within a container like this:

.. code-block:: shell

    [root@hostname ~]# docker exec -it pwa-admin1 bash
    root@2dd0cd671538:/# ls
    app  bin  boot  dev  etc  home  lib  lib64  media  mnt  opt  proc  root  run  sbin  srv  start.sh  sys  tmp  usr  var
    root@2dd0cd671538:/# ls -l app/api/config
    total 12
    drwxrwxr-x 2 11264 11264  146 Jan 24 22:06 auth
    -rw-rw-r-- 1 11264 11264 6096 May 23  2018 index.js
    drwxrwxr-x 4 11264 11264 4096 Jan 25 20:44 nginx
    drwxrwxr-x 2 11264 11264   55 May 23  2018 shared

Or directly execute commands like this:

.. code-block:: shell

    [root@hostname ~]# docker exec -it pwa-admin1 ls /app/api/config
    auth  index.js  nginx  shared


Firewall
--------

Docker will take care of its own firewall rules, so you don't have to worry about opening ports manually. 

By default, following are the ports used by nginx container:


* 443 (For PWA administrative GUI)
* 80 (For PWA configuration publisher)
* 9443 (For x509 authentication to PWA administrative GUI)


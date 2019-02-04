
# Basic Setup Flask App + uWSGI/NGINX over Docker

As stated by official Flask documentation, you shouldn't use Werkzeug as production server. An easy alternative to setup is NGINX, and you can find it at [NGINX Official Image](https://hub.docker.com/_/nginx).

*NOTE:*
	The main branch uses ubuntu as base, while this branch uses nginx-alpine.
	To boot nginx and uwsgi as services, we are using openrc.
	I reused nginx init.d script with few modifications to remove unused items for this image.
	The ubuntu based image has around 516 MB, while this has around 229 MB.
	I tried to pay attention to configuration details, but maybe I lost something around. Feel free to contribute!

This is a basic example of Flask application served by NGINX.

This specific repository does not consider a node for Load Balancer.

**Summary:**

**NGINX REQUEST** &rarr; *uWSGI_pass socket* &rarr; uWSGI &rarr; Flask App
then:
Flask App  &rarr; uWSGI &rarr; *uWSGI_pass socket* &rarr; **NGINX RESPONSE**

## Start-up options (NEW!)
If limitint the access of nginx server is a requirement, I added a parsing for ${ALLOWED} environment variable that you can add to the container
For example:

docker run --name ng -d -p 8080:80 --network=mynetwork -e ALLOWED="172.18.0.2;172.18.0.5;" nginx-python3

You need to understand what is happening!
ALLOWED is being parsed by spliting at semicolon and a permissions.conf file is being generated.
This permission.conf file will be included by nginx at site configurations (/etc/nginx/sites-available/default)
Each section of ALLOWED variable will generate an allow permission line:
By the end of permission.conf file a line will be added to avoid access by everyone else

```
allow $IP_1;
allow $IP_2;
allow $IP_3;

deny all;
```
I'm not trying to stop you to inject anything through this variable since it should the sysadmin the one to run the starting command. If added security is needed, please feel free to contribute to this repository :)

It is *very important* to notice that nginx configurations allow access by range. For this you only need to set a ip range such as:

docker run --name ng -d -p 8080:80 --network=mynetwork -e ALLOWED="172.18.0.0/16;172.17.0.3;" nginx-python3

in this case 172.17.0.3 and all IP addresses under 172.18.xxx.xxx will be allowed

If ALLOWED environment variable is not specified access *will be granted for everyone*

## Git
[Flask Nginx Docker](https://github.com/fsan/flask_nginx_docker_xp) &rarr; feel free to improve

**Folders:**
* app-setup:
    * files required to setup image during build
* kickstart:
    * start NGINX and uWSGI
* nginx:
    * nginx configuration
* packages:
    *  set of applications with *example application*
*  wsgi:
    *  uwsgi settings

**Basic configuration:**

*wsgi/app.ini:*
````
[uwsgi]
base =/packages/                # `base folder` path
module = example.bootstrap      # package + `flask app` py
callable = application          # `application object` inside `flask app`
````

## Docker Image
[Docker Image](https://cloud.docker.com/repository/registry-1.docker.io/motbus3/nginx-flask-python3) &rarr; feel free to improve

## Read More
- [Flask: Deploy to production](http://flask.pocoo.org/docs/1.0/tutorial/deploy/#run-with-a-production-server)
- [NGINX Settings](https://www.nginx.com/resources/wiki/start/topics/examples/full/)
- [PEP 3333: WSGI](https://www.python.org/dev/peps/pep-3333/)
 
## Some results:
**httperf:**

```
httperf --hog --server localhost --num-conns 600000 --ra 6000
httperf --hog --client=0/1 --server=localhost --port=80 --uri=/ --rate=6000 --send-buffer=4096 --recv-buffer=16384 --num-conns=600000 --num-calls=1
httperf: warning: open file limit > FD_SETSIZE; limiting max. # of open files to FD_SETSIZE
Maximum connect burst length: 415

Total: connections 575319 requests 575319 replies 575319 test-duration 100.810 s

Connection rate: 5706.9 conn/s (0.2 ms/conn, <=1022 concurrent connections)
Connection time [ms]: min 1.6 avg 169.1 max 4364.3 median 121.5 stddev 229.3
Connection time [ms]: connect 56.7
Connection length [replies/conn]: 1.000

Request rate: 5706.9 req/s (0.2 ms/req)
Request size [B]: 62.0

Reply rate [replies/s]: min 5285.3 avg 5743.4 max 5849.6 stddev 114.0 (20 samples)
Reply time [ms]: response 112.4 transfer 0.0
Reply size [B]: header 167.0 content 130.0 footer 0.0 (total 297.0)
Reply status: 1xx=0 2xx=175849 3xx=0 4xx=0 5xx=399470

CPU time [s]: user 11.10 system 88.13 (user 11.0% system 87.4% total 98.4%)
Net I/O: 2005.6 KB/s (16.4*10^6 bps)

Errors: total 24681 client-timo 0 socket-timo 0 connrefused 0 connreset 0
Errors: fd-unavail 24681 addrunavail 0 ftab-full 0 other 0

```
## TODO:
- Need to start NGINX and uWSGI as services and should not need start at ENTRYPOINT
- Load balancer node
- httpperf has about 24681 errors, but it is caused because my system cannot handle so much open files at same time. The average response is around 112.4 ms


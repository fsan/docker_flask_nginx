
# Basic Setup Flask App + uWSGI/NGINX over Docker

As stated by official Flask documentation, you shouldn't use Werkzeug as production server. An easy alternative to setup is NGINX, and you can find it at [NGINX Official Image](https://hub.docker.com/_/nginx).

This is a basic example of Flask application served by NGINX.

This specific repository does not consider a node for Load Balancer.

**Summary:**

**NGINX REQUEST** &rarr; *uWSGI_pass socket* &rarr; uWSGI &rarr; Flask App
then:
Flask App  &rarr; uWSGI &rarr; *uWSGI_pass socket* &rarr; **NGINX RESPONSE**

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
 
## TODO:
- Need to start NGINX and uWSGI as services and should not need start at ENTRYPOINT
- Load balancer node


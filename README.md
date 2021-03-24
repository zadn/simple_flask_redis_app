# Flask Redis Application
This repository contains code for a simple Flask and Redis application and the config to deploy using docker-compose.

The file `app.py` contains the code for Flask application and the `Dockerfile` uses this file besides `requirements.txt` 
to build the Docker image. Once the image is created you can start the application using `docker-compose`. The application uses
`Redis` as a data store and `Consul` for service discovery. All the images other than the web app is directly pulled from public
docker-hub repositories.   


# Build Docker Image

You can build the Docker image using this command:

```bash
docker build -t compose-flask .
```

# Build and Run with Docker Compose

Start the application from your directory:

```bash
$ docker-compose up --scale web=2
```

This will run two node of web application and all the others with single instances.  
If you have localhost access to your host, point your browser to `http://0.0.0.0:5000`, `http://127.0.0.1:5000`, or `http://localhost:5000`.
 If you do use a remote host, simply use that IP address and append `:5000` to the end.

You should see:

```
This Compose/Flask demo has been viewed 1 time(s).
```

When you refresh, you should see:

```This Compose/Flask demo has been viewed 2 time(s).```


Each time you refresh, the number should increment.

Stop the application with `CTRL+C` and refresh the page. You should receive something to the effect of `This site can't be reached`.

Restart the application with `docker-compose up -d`. Redis resets the count and you should see:

```This Compose/Flask demo has been viewed 1 time(s).```

Use `docker-compose ps` and you should get similar results:
```
        Name                      Command               State           Ports
--------------------------------------------------------------------------------------
composeflask_redis_1   docker-entrypoint.sh redis ...   Up      6379/tcp
composeflask_web_1     /bin/sh -c python app.py         Up      0.0.0.0:5000->5000/tcp

```
Run docker-compose stop to stop the containers:

```bash
$ docker-compose stop
Stopping composeflask_web_1 ... done
Stopping composeflask_redis_1 ... done
```
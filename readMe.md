# Adding Basic Authentication with Nginx as a Reverse Proxy

In this guide, we will set up an Nginx reverse proxy that will add basic authentication to an existing application. We will use Docker to power our Nginx reverse proxy.

### Prerequisites:

- A basic web application or service that is missing authentication
- Docker

### Steps: 
1. Create a Dockerfile using the following code:
``` Dockerfile
FROM nginx:1.19

# Install apache2-utils to get htpasswd command
RUN apt-get update -y && apt-get install -y apache2-utils && rm -rf /var/lib/apt/lists/*

# Basic auth credentials
ENV BASIC_USERNAME=username
ENV BASIC_PASSWORD=password

# Forward host and foward port as env variables
# google.com is used as a placeholder, to be replaced using environment variables
ENV FORWARD_HOST=google.com
ENV FORWARD_PORT=80

# Nginx config file
WORKDIR /
COPY nginx-basic-auth.conf nginx-basic-auth.conf

# Startup script
COPY run.sh ./
RUN chmod 0755 ./run.sh
CMD [ "./run.sh" ]
```

2. Create a file named nginx-basic-auth.conf using the following code:

``` perl
server {
 listen 80 default_server;

 location / {
     auth_basic             "Restricted";
     auth_basic_user_file   .htpasswd;

     proxy_pass             http://${FORWARD_HOST}:${FORWARD_PORT};
     proxy_read_timeout     900;
 }
}
```

3. Create a file named run.sh using the following code:

``` bash
#!/bin/sh

# nginx config variable injection
envsubst < nginx-basic-auth.conf > /etc/nginx/conf.d/default.conf

# htpasswd for basic authentication
htpasswd -c -b /etc/nginx/.htpasswd $BASIC_USERNAME $BASIC_PASSWORD

nginx -g "daemon off;"
```

4. Build the Docker image by running the command docker build -t nginx-basic-auth .

5. Run the image by running the command docker run -it -p 80:80 --env BASIC_USERNAME=<username> --env BASIC_PASSWORD=<password> --env FORWARD_HOST=<hostname> --env FORWARD_PORT=<port> nginx-basic-auth`

### Building the Docker Image: 
Building the Docker image is as simple as running the command below:

```
docker build -t nginx-basic-auth .
```

### Running the Docker Container
We can now use the image to run a container. Here's an example command to run the container:

``` bash
docker run -it -p 80:80 --env BASIC_USERNAME=john.doe --env BASIC_PASSWORD=myp@ssword! --env FORWARD_HOST=localhost --env FORWARD_PORT=8080 nginx-basic-auth
```

Browsing to http://localhost will prompt you for credentials.

### If You Need A Sample Project To Test
1. Navigate to demo folder
2. Build Docker Image: 
```powershell
docker build -t springio/gs-spring-boot-docker .
```
3.Run Docker Image
```powershell
docker run -p 8080:8080 --name spring-boot springio/gs-spring-boot-docker
```

### If Installing apache2-utils is not possible:

1. I have added a java project that will generate the .htpasswd file for nginx. This really shouldn't be used but if you need it it's their.

2. How to generate .httpasswd file
```powershell

java -jar basic-auth-file-generator-1.0.0.jar username password

```

3. We are limited to only having one user in the .htpasswd file. Could be extented if needed. 
 

# workspace

My workspace in Docker.

### Building

    docker build -t [IMAGE]:[TAG] .

### Running

This depends on your own configuration, but for example:

    docker run -ti -v ~/work:/root/work --name ws [IMAGE]:[TAG]

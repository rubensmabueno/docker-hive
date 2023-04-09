# Project: Hive Docker Image
This is an open-source project that provides a Docker image for building and running the Hive (or Metastore) server with
Postgresql. The Docker image is based on OpenJDK 8 and includes Hive version 2.3.9.

## Table of Contents
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [Configuration](#configuration)
- [License](#license)
- [Contact](#contact)

## Features
- OpenJDK 8 as the base image.
- Hive 2.3.9 pre-installed.
- Postgresql 9.5 pre-installed for database storage.
- Prometheus JMX exporter pre-installed for monitoring.

## Prerequisites
- Docker installed on your system.

## Installation
There is no need to install the Docker image as it is available on DockerHub. You can download the image using the following command:

```bash
docker pull rubensminoru/hadoop
```

### Building image manually
1. Clone the repository:
```bash
git clone https://github.com/rubensmabueno/docker-hive.git
```

2. Build the Docker image:
```bash
docker build -t your-image-name .
```

## Usage
### Option 1: Using Docker Compose
1. Create a docker-compose.yml file with the following content:

```
version: '3'

services:
  metastore:
    image: rubensminoru/hive
    command: /opt/hive/bin/hive --service metastore
    volumes:
    - ./config/core-site.xml:/opt/hive/conf/core-site.xml
    - ./config/hive-site.xml:/opt/hive/conf/hive-site.xml
    - ./config/ivysettings.xml:/opt/hive/conf/ivysettings.xml
    - ./config/hive-log4j2.properties:/opt/hive/conf/log4j2.properties
    - ./config/jmx-config.yml:/opt/jmx_prometheus_javaagent/config.yml
    environment:
    - HADOOP_OPTS=-javaagent:/opt/jmx_prometheus_javaagent/jmx_prometheus_javaagent.jar=5556:/opt/jmx_prometheus_javaagent/config.yml
    ports:
    - 9083:9083
    - 5556:5556
    depends_on:
      postgresql:
        condition: service_healthy
    healthcheck:
      test: ["CMD", "nc", "-w", "1", "localhost", "9083"]
      interval: 10s
      timeout: 5s
      retries: 3
  postgresql:
    image: postgres:9.5
    volumes:
    - "./tmp/postgres:/var/lib/postgresql/data"
    ports:
    - 5432:5432
    environment:
    - POSTGRES_PASSWORD=hive
    - POSTGRES_USER=hive
    - POSTGRES_DB=metastore
    healthcheck:
      test: [ "CMD", "pg_isready", "-U", "metastore" ]
      interval: 10s
      timeout: 5s
      retries: 3
```

2. Start the containers:
```bash
docker-compose up
```

3. Access the Hive Metastore through port 9083.

### Option 2: Usage with Docker Run
1. Start a PostgreSQL container:
```bash
docker run --name postgresql -e POSTGRES_PASSWORD=hive -e POSTGRES_USER=hive -e POSTGRES_DB=metastore -d postgres:9.5
```

2. Start the Hive Metastore container:
```bash
docker run -d --name hive-metastore -p 9083:9083 -p 5556:5556 \
  -v "$(pwd)/config/core-site.xml:/opt/hive/conf/core-site.xml:ro" \
  -v "$(pwd)/config/hive-site.xml:/opt/hive/conf/hive-site.xml:ro" \
  rubensminoru/hive-metastore
```

### Configuration
- To customize the Hive Metastore configuration, edit the hive-site.xml and core-site.xml file located in /opt/hive/conf/ within the container.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact
- Maintainer: Rubens Minoru Andako Bueno
- Email: rubensmabueno@hotmail.com
- Feel free to reach out for any questions, issues, or contributions.

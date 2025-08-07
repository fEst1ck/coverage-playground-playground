# README

This is an example docker setup for our experimental fuzzer [coverage-playground](https://github.com/fEst1ck/coverage-playground).

You can use it to fuzz your PUT (program under test) by customizing

- `fetch_put.sh` to fetch the source of the PUT
- `build_put.sh` to build the PUT
- `corpus.sh` to fetch the corpus
- `fuzz.sh` to run the fuzzing command

# Usage

```bash
# Build the docker image
docker build -t fuzzer .

# Run the container
docker run -it fuzzer /bin/bash

# Run the fuzzing command in the container
/fuzz.sh
```

# System Requirements

Tested on:
- Ubuntu 24.04.1 LTS
- Docker version 27.5.1, build 27.5.1-0ubuntu3~24.04.2

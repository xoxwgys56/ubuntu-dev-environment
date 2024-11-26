# Ubuntu dev environment

for run ubuntu for development environment using docker

## Stack

- ubuntu@24.04
- pyenv
- poetry

## Usage

```shell
# build image
docker build -t ubuntu-dev .
# run container interactive mode
docker run --rm -it --name ubuntu_dev_container ubuntu-dev zsh
```

## TODO

- [ ] improve zsh environment
  - https://gist.github.com/noahbliss/4fec4f5fa2d2a2bc857cccc5d00b19b6

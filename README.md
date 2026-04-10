# oh-my-pi Docker image

Container image for [oh-my-pi](https://github.com/can1357/oh-my-pi), always up to date with the latest release.

## Usage

Build and run locally:

```sh
make build
make run
```

Pull from Docker Hub:

```sh
docker pull mongrelion/oh-my-pi:latest
docker pull mongrelion/oh-my-pi:14.0.4
```

## How it works

A GitHub Actions workflow polls the npm registry every 5 minutes. When a new version of `@oh-my-pi/pi-coding-agent` is published, it builds a new image and pushes it to Docker Hub with both the version tag and `latest`. If the image for that version already exists, the build is skipped.

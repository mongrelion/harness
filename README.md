# Harness
> **NOTE**: Not fit for public consumption. This is basically my local development environment made public with the tools that **I** need. Use at your own risk.

Container image with a few harnesses:
- [pi](https://pi.dev)
- [oh-my-pi](https://github.com/can1357/oh-my-pi)
- [opencode](https://opencode.ai)



# Why?
Security. Most of these harnesses run untrusted code. By running them in a container, we can isolate them from the host system and limit the potential damage
they can cause. Additionally, by keeping the image up to date with the latest release of each one of them, we can ensure that we have the latest
security patches and features.

## Usage
I have a function in my `bashrc` that looks like this:
```sh
function harness() {
  local tool=$1
  docker run \
    --rm \
    -it \
    --user $(id -u):$(id -g) \
    --workdir $PWD \
    --mount type=bind,src=$PWD,dst=$PWD \
    --mount type=bind,src=$HOME/path/to/my/rc/files/omp,dst=/home/coder/.omp \
    --mount type=bind,src=$HOME/path/to/my/rc/files/pi,dst=/home/coder/.pi \
    --mount type=bind,src=$HOME/path/to/my/rc/files/opencode,dst=/home/coder/.config/opencode \
    --mount type=bind,src=$HOME/.agents,dst=/home/coder/.agents \
    --mount type=bind,src=$HOME/.gitconfig,dst=/home/coder/.gitconfig \
    --env-file $HOME/.env/harness \
    mongrelion/harness $tool
end
```

Then, when I want to run a tool, I just run `harness <tool>`, for example:
```sh
cd /path/to/my/project
harness pi
```

In the `~/.env/harness` file, I have some environment variables that I want to pass to the container, for example:
```sh
OPENROUTER_API_KEY=sk-...
GITHUB_TOKEN=ghp-...
```

## Development
Make whatever changes you want around. Then have a look at the next section.

### Build and run locally:

```sh
make build
make run
```

Pull from Docker Hub:

```sh
docker pull mongrelion/harness:latest
```

## How it works

A GitHub Actions workflow runs every day at midnight and builds the image. It then pushes it to Docker Hub with the `latest` tag. This way, we always have the
latest version of the image available.

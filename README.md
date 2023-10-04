
# Setup

`git clone --recurse-submodules git@github.com:mynameis7/meowth-docker.git` 

or 

`git clone --recurse-submodules https://github.com/mynameis7/meowth-docker.git`

`docker compose up -d --build`

# 'requirements.txt' Changes
1. updated `asyncpg` to `0.28.0` (because there's a broken pyproject.toml in 0.25.0)
2. removed `pkg_resources==0.0.0` (because it's unnecessary, part of setuptools)
3. updated `backports.zoneinfo==0.2.1` to `backports.zoneinfo==0.2.1;python_version<"3.9"` (Because [StackOverflow link](https://stackoverflow.com/questions/71712258/error-could-not-build-wheels-for-backports-zoneinfo-which-is-required-to-insta))

# Why submodules?
1. I wanted to make sure that the versions of code i'm genenerally running against are "static" 
2. Cloning the submodules up front saves time in the docker build steps compared to installing git in the container and cloning in the container

# Setup

`git clone --recurse-submodules git@github.com:mynameis7/meowth-docker.git` 

or 

`git clone --recurse-submodules https://github.com/mynameis7/meowth-docker.git`

`docker compose up -d --build`

# 'requirements.txt' Changes
1. removed `pkg_resources==0.0.0` (because it's unnecessary, part of setuptools)
2. updated `backports.zoneinfo==0.2.1` to `backports.zoneinfo==0.2.1;python_version<"3.9"` (Because [StackOverflow link](https://stackoverflow.com/questions/71712258/error-could-not-build-wheels-for-backports-zoneinfo-which-is-required-to-insta))
3. updated `tzdata==2021.5` to `tzdata>=2021.5` 

# Why submodules?
1. I wanted to make sure that the versions of code I'm genenerally running against are "static" 
2. Cloning the submodules up front saves time in the docker build steps compared to installing git in the container and cloning in the container
3. I wanted to stay on current "upstream" codebase while I work on the docker image pieces and ensure splitting dependencies 
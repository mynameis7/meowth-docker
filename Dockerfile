FROM python:3.10 as base
RUN apt-get update && apt-get install -y \
                    build-essential \
                    cmake \
                    libgflags-dev \
                    libgeos++-dev \
                    libgoogle-glog-dev \
                    libgtest-dev \
                    libproj-dev \
                    libssl-dev \
                    swig \
                    pkg-config \
                    python3-dev

RUN python -m venv /venv
ENV PATH=/venv/bin:$PATH

COPY abseil-cpp /abseil/
WORKDIR /abseil/build
RUN cmake \
    -D CMAKE_POSITION_INDEPENDENT_CODE=ON \
    -D CMAKE_CXX_STANDARD=14 \
    -D ABSL_ENABLE_INSTALL=ON \
    -D CMAKE_INSTALL_PREFIX=/usr/ \
    ..
RUN cmake --build . --target install
COPY s2geometry /s2/
WORKDIR /s2/build
RUN  cmake \
          -D CMAKE_PREFIX_PATH=/usr/ \
          -D WITH_PYTHON=ON \
          -D CMAKE_CXX_STANDARD=14 \
          -D CMAKE_INSTALL_PREFIX=/usr/ \
          ..
RUN make -j $(nproc)
RUN make install

RUN python -m pip install cmake_build_extension wheel
WORKDIR /s2/
RUN python setup.py bdist_wheel

FROM python:3.10 as app
ENV BOT_MASTER=""
ENV BOT_TOKEN=""
ENV PG_USERNAME="postgres"
ENV PG_DATABASE="postgres"
ENV PG_HOSTNAME="pgdb"
ENV PG_PASSWORD="password"
RUN apt-get update && apt-get install -y python3-dev
COPY --from=base /s2/dist /s2-dep/
RUN python -m pip install /s2-dep/s2geometry-0.11.0.dev1-cp310-cp310-linux_x86_64.whl
RUN ln -s /usr/local/lib/python3.10/site-packages/s2geometry /usr/local/lib/python3.10/site-packages/pywraps2

WORKDIR /code
COPY Persian/requirements.txt requirements.txt
RUN python -m pip install -r requirements.txt

COPY Persian /code/

COPY entrypoint.sh /code/meowth/entrypoint.sh
WORKDIR /code/meowth
CMD [ "/bin/sh", "entrypoint.sh" ]
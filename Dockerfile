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
          -D PYTHON_LIBRARY:FILEPATH=$(python -c "from distutils.sysconfig import get_config_vars; d=get_config_vars(); print('/usr/lib/{}/{}'.format(d['MULTIARCH'], d['INSTSONAME']))") \
          -D PYTHON_INCLUDE_DIR:PATH=$(python -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
          -D PYTHON_EXECUTABLE:FILEPATH=$(which python) \
          ..
RUN make -j $(nproc)
RUN make install

RUN python3 -m pip install cmake_build_extension wheel
WORKDIR /s2/
RUN python3 setup.py bdist_wheel

FROM python:3.10 as app
ENV BOT_MASTER=""
ENV BOT_TOKEN=""
RUN apt-get update && apt-get install -y python3-dev
COPY --from=base /s2/dist /s2-dep/
RUN python3 -m pip install /s2-dep/s2geometry-0.11.0.dev1-cp310-cp310-linux_x86_64.whl
COPY Meowth /code/
COPY requirements.txt /code/
WORKDIR /code
RUN python3 -m pip install -r requirements.txt

COPY entrypoint.sh /code/entrypoint.sh
ENTRYPOINT [ "/bin/sh", "entrypoint.sh" ]
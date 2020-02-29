FROM arm32v7/debian:buster-slim as arm32v7-pytorch

RUN apt-get update -q && apt-get install -y --no-install-recommends \
        g++ nano git m4 make cython sudo locales curl vim wget apt-utils \
        && rm -rf /var/lib/apt/lists/*

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -q && apt-get install -y --no-install-recommends \
    sudo apt-utils locales \
    git curl vim nano m4 cython \
    unzip openssh-client wget \
    build-essential cmake \
    libopenblas-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    tar \
    libatlas-base-dev \
    && rm -rf /var/lib/apt/lists/*

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

RUN apt-get update -q && apt-get install -y --no-install-recommends \
    libopenblas-dev libblas-dev python3-dev python3-pip zlib1g-dev \
    && python3 -m pip install --upgrade --no-cache-dir pip setuptools wheel \
    && python3 -m pip install --no-cache-dir virtualenv numpy PyYMAL tkinter\
    && rm -rf /var/lib/apt/lists/*


RUN apt-get update -q && apt-get install -y --no-install-recommends \
    libtiff5-dev libjpeg62-turbo-dev  libopenjp2-7-dev zlib1g-dev \
    libfreetype6-dev liblcms2-dev libwebp-dev tcl8.6-dev tk8.6-dev python3-tk \
    libharfbuzz-dev libfribidi-dev \
    && rm -rf /var/lib/apt/lists/*


RUN cd /tmp && \
    wget --no-check-certificate https://raw.github.com/marcusvlc/pytorch-on-rpi/master/torch-1.4.0a0+7f73f1d-cp37-cp37m-linux_armv7l.whl && \
    wget --no-check-certificate https://raw.github.com/marcusvlc/pytorch-on-rpi/master/torchvision-0.5.0a0+85b8fbf-cp37-cp37m-linux_armv7l.whl && \
    python3 -m pip install --no-cache-dir torch-*-linux_armv7l.whl && \
    python3 -m pip install --no-cache-dir torchvision-*linux_armv7l.whl && \
    rm -rf /tmp/*.whl && \
    cd /usr/local/lib/python3.7/dist-packages/torch  && \
    for i in _C.cpython*.so _dl.cpython-*.so; do ln -sf "$i" "$(echo $i | awk -F '.' '{print $1 ".so"}')" ; done && \
    cd - && \
    python3 -c 'import torch, torchvision; print("PYTORCH VERSION: {} \nTORCHVISON VERSION:{}".format(torch.__version__,torchvision.__version__));'



FROM arm32v7-pytorch as with-ml-tools

ARG PYTHON_ML="visdom onnx \
                sklearn pandas \
                matplotlib plotly seaborn futures \
                ImageHash mock pytest pytest-mock \
                PyWavelets PyYAML six terminaltables \
                tqdm future scikit-image wandb"

ARG GIT_URL="https://gitlab.com/arjun.neupane/python-wheels/-/raw"

ARG GIT_BRANCH="arm32v7/pytorch/ml/v1.4"

ARG ARCHIVE_FILE="arm32v7.wheels.tar.gz"

ARG WHEEL_URL="${GIT_URL}/${GIT_BRANCH}/${ARCHIVE_FILE}"

RUN TEMP_DIR="$(mktemp -d)" && cd "${TEM_DIR}" && \
    wget --no-check-certificate "${WHEEL_URL}" && \
    tar -xvzf "${ARCHIVE_FILE}" -C "${TEMP_DIR}" && rm -rf "${ARCHIVE_FILE}" && \
    python3 -m pip install --no-cache-dir -f "${TEMP_DIR}/wheels" ${PYTHON_ML} && \
    rm -rf "${TEMP_DIR}"

RUN apt-get update -q && apt-get install -y --no-install-recommends \
    gfortran \
    libatlas3-base \
    libblas3 \
    liblapack3 \
    protobuf-compiler \
    libprotoc17 && \
    rm -rf /var/lib/apt/lists/*

FROM with-ml-tools as login-as-currentuser

COPY entrypoint.sh  /entrypoint.sh

RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

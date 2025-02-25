# Base image: Python 3.11 (CPU 기반)
FROM python:3.11.11-slim-bullseye

# 작업 디렉토리 설정
WORKDIR /workspace

# 시스템 업데이트 및 필수 패키지 설치 (git 포함)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    libopenblas-dev \
    libblas-dev \
    liblapack-dev \
    gfortran \
    wget \
    openssh-server \
    openmpi-bin \
    openmpi-common \
    libopenmpi-dev \
 && rm -rf /var/lib/apt/lists/*

# pip 업그레이드 후, PyTorch, DGL (CPU 환경용), 그리고 추가 Python 패키지 설치
RUN pip install --no-cache-dir --upgrade pip \
 && pip install --no-cache-dir torch==2.1.2 torchvision==0.16.2 torchaudio==2.1.2 --index-url https://download.pytorch.org/whl/cpu \
 && pip install --no-cache-dir dgl -f https://data.dgl.ai/wheels/torch-2.1/repo.html \
 && pip install --no-cache-dir "numpy<2" scipy networkx tqdm mpi4py ogb

# 현재 빌드 컨텍스트(프로젝트 전체)를 /workspace로 복사
COPY . /workspace

# SSH 서버 설정: root 암호 설정 및 SSH 접속 허용, SSH 관련 디렉토리 생성 및 권한 부여
RUN mkdir -p /root/.ssh && \
    ssh-keygen -t rsa -b 4096 -f /root/.ssh/id_rsa -q -N "" && \
    cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys && \
    chmod 600 /root/.ssh/authorized_keys && \
    echo "root:DistDGL" | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    mkdir -p /var/run/sshd && \
    mkdir -p /run/sshd && chmod 0755 /run/sshd

# 22번 포트 노출 (SSH)
EXPOSE 22

# 컨테이너 시작 시 SSH 데몬 실행
CMD ["/usr/sbin/sshd", "-D"]

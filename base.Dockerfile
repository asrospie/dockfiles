FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    file \
    git \
    procps \
    ca-certificates

RUN apt update && apt install -y

RUN useradd -m linuxbrew
USER linuxbrew

# PYTHON AND NEOVIM INSTALL
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
ENV PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:${PATH}"
RUN brew install neovim
RUN brew install python@3.14


# STARSHIP CONFIG
RUN brew install starship
USER root
RUN echo 'eval "$(starship init bash)"' > /root/.bashrc


# GO INSTALL
ENV GO_VERSION=1.25.5
RUN curl -fsSL https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz \
    | tar -C /usr/local -xz

ENV GOROOT=/usr/local/go
ENV GOPATH=/go
ENV PATH=$GOROOT/bin:$GOPATH/bin:$PATH

# SETUP NEOVIM ENV
WORKDIR /root/.config
RUN git clone https://github.com/asrospie/nvim.git


WORKDIR /root/workspace

CMD ["/bin/bash"]

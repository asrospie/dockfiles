FROM ubuntu:24.04

RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    file \
    git \
    procps \
    ca-certificates \
    sudo

RUN apt update && apt install -y

# Create custom alec user
RUN useradd -m alec \
    && echo "alec ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
WORKDIR /home/linuxbrew
# add alec to owner of /home/linuxbrew for brew install purposes
RUN chown -R alec:alec /home/linuxbrew
USER alec

# PYTHON AND NEOVIM INSTALL
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
ENV PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:${PATH}"
RUN brew install neovim
RUN brew install python@3.14


# STARSHIP CONFIG
RUN brew install starship
RUN echo 'eval "$(starship init bash)"' > /home/alec/.bashrc


USER root
# GO INSTALL
ENV GO_VERSION=1.25.5
RUN curl -fsSL https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz \
    | tar -C /usr/local -xz

ENV GOROOT=/usr/local/go
ENV GOPATH=/go
ENV PATH=$GOROOT/bin:$GOPATH/bin:$PATH

# SETUP NEOVIM ENV
USER alec
WORKDIR /home/alec/.config
RUN git clone https://github.com/asrospie/nvim.git


WORKDIR /home/alec/workspace

CMD ["/bin/bash"]

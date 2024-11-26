FROM ubuntu:24.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

RUN set -ex; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        build-essential \
        git \
        vim \
        curl \
        wget \
        python3 \
        python3-pip \
        sudo \
        net-tools \
        iputils-ping \
        openssh-server \
        zsh \
        libssl-dev \
        libbz2-dev \
        libreadline-dev \
        libsqlite3-dev \
        libffi-dev \
        libncursesw5-dev \
        xz-utils \
        tk-dev \
        libxml2-dev \
        libxmlsec1-dev \
        liblzma-dev \
        ; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*;

# Create a new user 'devuser' with password 'password' and default shell zsh
RUN useradd -ms /bin/zsh devuser && \
    echo 'devuser:password' | chpasswd && \
    adduser devuser sudo

# Set up SSH server
RUN mkdir /var/run/sshd

USER devuser
WORKDIR /home/devuser

# Install oh-my-zsh for 'devuser'
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install pyenv
RUN curl https://pyenv.run | bash

# Install poetry
RUN curl -sSL https://install.python-poetry.org | python3 -

# Install zsh auto suggestion
RUN git clone https://github.com/zsh-users/zsh-autosuggestions \
    ${ZSH_CUSTOM:-/home/devuser/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# Install zsh syntax highlighting
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
    ${ZSH_CUSTOM:-/home/devuser/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  
COPY --chown=devuser:devuser ./zshrc /home/devuser/.zshrc

WORKDIR /home/devuser/workspace

COPY --chown=devuser:devuser ./entrypoint.sh /home/devuser/entrypoint.sh

CMD [ "/bin/bash", "/home/devuser/entrypoint.sh" ]
# Base Kali Linux image
FROM kalilinux/kali-rolling

# Set environment to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update system and fix potential issues
RUN apt update && \
    apt -y upgrade && \
    apt -y autoremove && \
    apt -y autoclean

# Install kali-linux-large with error handling
RUN apt update && \
    apt -y install --fix-missing kali-linux-large || \
    (apt -y --fix-broken install && apt -y install --fix-missing kali-linux-large)

# Install additional tools and network utilities
RUN apt update && \
    apt -y install \
    git \
    python3 \
    python3-pip \
    iputils-ping \
    traceroute \
    dnsutils \
    net-tools \
    iproute2 \
    telnet \
    bind9-dnsutils \
    && apt clean && \
    rm -rf /var/lib/apt/lists/*

# Install dirsearch
RUN git clone https://github.com/maurosoria/dirsearch.git /opt/dirsearch && \
    chmod +x /opt/dirsearch/dirsearch.py && \
    ln -s /opt/dirsearch/dirsearch.py /usr/local/bin/dirsearch

# Create data folder
RUN mkdir -p /data

# Set working directory
WORKDIR /root

# Default command
CMD ["/bin/bash"]

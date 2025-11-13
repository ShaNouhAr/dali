# Base Kali Linux image
FROM kalilinux/kali-rolling

# Update and install kali-linux-large
RUN apt update && \
    apt -y install kali-linux-large git python3 python3-pip && \
    apt clean && \
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

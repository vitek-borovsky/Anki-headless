FROM ubuntu:22.04

ARG ANKI_VERSION=25.02

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
ENV DISPLAY=:1

RUN groupadd -g 1001 anki && \
    useradd -u 1001 -g anki -m anki

RUN apt update && apt install -y \
    locales \
    wget \
    unzip \
    python3 \
    python3-pip \
    xvfb \
    libxcb-xinerama0 \
    libxkbcommon-x11-0 \
    libxkbfile1 \
    libegl1 \
    libnss3 \
    libxss1 \
    libasound2 \
    libatk1.0-0 \
    libgtk-3-0 \
    zstd \
    x11-xserver-utils \
 && locale-gen en_US.UTF-8 \
 && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/ankitects/anki/releases/download/${ANKI_VERSION}/anki-${ANKI_VERSION}-linux-qt6.tar.zst \
    && tar --use-compress-program=unzstd -xvf anki-${ANKI_VERSION}-linux-qt6.tar.zst \
    && mv anki-${ANKI_VERSION}-linux-qt6 /opt/anki \
    && rm anki-${ANKI_VERSION}-linux-qt6.tar.zst

VOLUME [ "/home/anki/.local/share/Anki2" ]
EXPOSE 8765

USER anki
ENV PATH="/opt/anki:$PATH"

# CMD xvfb-run -s "-screen 0 1024x768x24" anki --platform offscreen
# CMD xvfb-run -s "-screen 0 640x480x16" anki --platform offscreen
# CMD xvfb-run -s "-screen 0 480x270x16" anki --platform offscreen
# CMD xvfb-run -s "-screen 0 320x180x16" anki --platform offscreen
CMD xvfb-run -s "-screen 0 256x144x16" anki --platform offscreen
# CMD xvfb-run -s "-screen 0 256x144x8" anki --platform offscreen

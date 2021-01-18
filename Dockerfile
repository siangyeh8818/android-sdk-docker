FROM ubuntu:18.04

ENV ANDROID_SDK_HOME /tools/android-sdk
ENV ANDROID_SDK_ROOT /tools/android-sdk
ENV ANDROID_HOME /tools/android-sdk
ENV ANDROID_SDK /tools/android-sdk
ENV PATH $PATH:$ANDROID_HOME/:$ANDROID_HOME/bin:$ANDROID_HOME/platform-tools
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

ENV DEBIAN_FRONTEND noninteractive

RUN dpkg --add-architecture i386

RUN  dpkg --add-architecture i386 && apt-get update -yqq && apt-get install -y \
  curl \
  expect \
  git \
  make \
  libc6:i386 \
  libgcc1:i386 \
  libncurses5:i386 \
  libstdc++6:i386 \
  zlib1g:i386 \
  openjdk-8-jdk \
  wget \
  unzip \
  vim \
  openssh-client \
  locales \
  nodejs \
  npm \
  && apt-get clean

RUN  mkdir -p /tools/android-sdk && rm -rf /var/lib/apt/lists/* && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG en_US.UTF-8

RUN groupadd android && useradd -d /tools/android-sdk -g android -u 1000 android

COPY tools /tools

WORKDIR /tools/cmdline-tools/bin

#RUN yes | /tools/cmdline-tools/bin/sdkmanager --licenses --sdk_root=/tools/android-sdk || true

RUN yes | ./sdkmanager  "platform-tools" --sdk_root=/tools/android-sdk

RUN yes | ./sdkmanager "platforms;android-28" --sdk_root=/tools/android-sdk

WORKDIR /tools

RUN wget https://downloads.gradle-dn.com/distributions/gradle-4.6-bin.zip && unzip gradle-4.6-bin.zip

ENV PATH $PATH:/tools/gradle-4.6/bin
RUN  gradle -v

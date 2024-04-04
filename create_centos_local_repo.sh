#!/bin/bash

# 사용자 디렉토리 확인
user_dir=$(eval echo ~$SUDO_USER)

# 현재 실행 위치 확인
script_dir=$(pwd)

# 사용자 버전 확인
centos_version=$(cat /etc/centos-release | cut -d ' ' -f4)

echo $centos_version

# 사용자에 맞는 버전 선택
if [[ $centos_version == "7.9"* ]]; then
  iso_file="CentOS-7-x86_64-DVD-2009.iso"
elif [[ $centos_version == "7.8"* ]]; then
  iso_file="CentOS-7-x86_64-DVD-2003.iso"
elif [[ $centos_version == "7.5"* ]]; then
  iso_file="CentOS-7-x86_64-DVD-1804.iso"
else
  echo "Unsupported CentOS version"
  exit 1
fi

# 로컬 레포지토리 설치
mkdir /tmp/repo
mount -o loop $script_dir/$iso_file /tmp/repos
mkdir /root/repos
cp -rfvp /tmp/repos/* /root/repos
unmount /tmp/repos
rm -rf /tmp/repos

# 기존 레포지토리 삭제
rm -rf /etc/yum.repos.d/CentOS-*


# 레포지토리 설정
echo "[local-centos]
name=local
baseurl=file:///root/repos
enabled=1
gpgcheck=0" > /etc/yum.repos.d/local.repo

# 레포지토리 확인
yum repolist


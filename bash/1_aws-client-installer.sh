#!/bin/bash
# Check Process Permission
echo "=====> Check process permission"
if [[ $EUID -ne 0 ]]; then
  echo "[ERROR] 스크립트는 sudo 또는 root 권한으로 실행해야 합니다."
  exit 1
else
  echo "- Process Permission check success."
fi

# Set Up
echo -e "\n=====> S3 client check"
if ! command -v aws &> /dev/null; then
  echo "[INFO] AWS CLI is not installed. Installing AWS CLI..."

  # AWS CLI 다운로드
  if ! curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"; then
    echo "[ERROR] AWS CLI 다운로드에 실패했습니다. 인터넷 환경을 점검 후 다시 실행하시기 바랍니다."
    exit 1
  fi

  unzip awscliv2.zip
  sudo ./aws/install

  # 설치 확인
  if ! command -v aws &> /dev/null; then
    echo "[ERROR] AWS CLI 설치에 실패했습니다. ./aws/install 을 다시 실행하여 설치하시기 바랍니다."
    exit 1
  fi

  echo "[INFO] AWS CLI가 성공적으로 설치되었습니다."
else
  echo "[INFO] AWS CLI가 설치되어 있습니다."
  aws --version
fi
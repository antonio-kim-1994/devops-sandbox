#!/bin/bash
echo "=====> Check process permission"
# Check if script is run as root
if [[ $EUID -eq 0 ]]; then
  echo "스크립트가 sudo 권한으로 실행됐습니다."
  echo "이 경우 aws 인증 정보가 root 계정에 생성됩니다."
  read -p "계속 진행하시겠습니까? (yes / no) : " USER_RESPONSE

  # 사용자 응답 처리
  case "$USER_RESPONSE" in
    [Yy][Ee][Ss])  # "yes" 입력 시 계속 진행
      echo "계속 진행합니다."
      ;;
    [Nn][Oo])  # "no" 입력 시 종료
      echo "스크립트를 종료합니다."
      exit 1
      ;;
    *)  # 잘못된 입력 처리
      echo "잘못된 입력입니다. 'yes' 또는 'no'를 입력해주세요."
      exit 1
      ;;
  esac
fi

# Configure AWS Credentials
echo -e "\n=====> AWS Access Key 및 Secret Key 등록"
read -p "AWS 프로파일 이름을 입력하세요 (기본값: default): " AWS_PROFILE
AWS_PROFILE=${AWS_PROFILE:-default}

read -p "AWS Access Key ID: " AWS_ACCESS_KEY
read -p "AWS Secret Access Key: " AWS_SECRET_KEY
read -p "AWS Region (기본값: ap-northeast-2): " AWS_REGION
AWS_REGION=${AWS_REGION:-ap-northeast-2} # 기본값 설정

aws configure set aws_access_key_id "$AWS_ACCESS_KEY" --profile "$AWS_PROFILE"
aws configure set aws_secret_access_key "$AWS_SECRET_KEY" --profile "$AWS_PROFILE"
aws configure set region "$AWS_REGION" --profile "$AWS_PROFILE"

# Check AWS Credentials
echo -e "\n=====> AWS 사용자 정보 확인"
aws configure list --profile "$AWS_PROFILE"

echo -e "\n=====> AWS STS 자격 증명 확인"
if ! aws sts get-caller-identity --profile "$AWS_PROFILE" &> /dev/null; then
  echo "[ERROR] AWS 자격 증명이 올바르지 않습니다. 다시 확인하세요."
  exit 1
else
  echo "- Validate AWS Identity"
fi

echo -e "\nAWS CLI 설정이 완료되었습니다 !"
exit 0
#!/bin/bash
S3_BUCKET=

# Check AWS CLI installed
if ! command -v aws &> /dev/null; then
  echo "[ERROR] AWS CLI가 설치되어 있지 않습니다. 먼저 AWS CLI를 설치해주세요."
  exit 1
fi

# User Input
read -p "업로드할 파일명 입력: " FILE_PATH

if [[ ! -f "$FILE_PATH" ]]; then
  echo "[ERROR] 입력한 파일이 존재하지 않습니다: $FILE_PATH"
  exit 1
fi

FILE_NAME=$(basename "$FILE_PATH")

echo "=====> S3 업로드 진행 중..."
if aws s3 cp "$FILE_PATH" "s3://$S3_BUCKET/$FILE_NAME"; then
  echo "파일 업로드 성공: s3://$S3_BUCKET/$FILE_NAME"
else
  echo "[ERROR] $FILE_NAME 파일 업로드 실패"
  exit 1
fi

exit 0
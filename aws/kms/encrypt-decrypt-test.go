package main

import (
	"context"
	"encoding/base64"
	"fmt"
	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/kms"
	"log"
)

const kmsKeyID = "" // KMS Key ID

func main() {
	cfg, err := config.LoadDefaultConfig(
		context.Background(),
		config.WithSharedConfigProfile("devops"), // sso profile name
		config.WithRegion("ap-northeast-2"),
	)
	if err != nil {
		log.Fatalf("failed to load AWS config: %v", err)
	}

	kmsClient := kms.NewFromConfig(cfg)

	// 암호화할 데이터
	plaintext := "Hello, AWS KMS!"

	// KMS 암호화 요청
	encryptData, err := EncryptData(kmsClient, plaintext)
	if err != nil {
		log.Fatalf("failed to encrypt data: %v", err)
	}
	fmt.Print("Encrypted data: ", encryptData)

	decryptData, err := DecryptData(kmsClient, encryptData)
	if err != nil {
		log.Fatalf("failed to decrypt data: %v", err)
	}
	fmt.Print("Decrypted data: ", decryptData)
}

func EncryptData(client *kms.Client, plaintext string) (string, error) {
	input := &kms.EncryptInput{
		KeyId:     aws.String(kmsKeyID),
		Plaintext: []byte(plaintext),
	}

	result, err := client.Encrypt(context.Background(), input)
	if err != nil {
		return "", err
	}

	return base64.StdEncoding.EncodeToString(result.CiphertextBlob), nil
}

func DecryptData(client *kms.Client, encryptedBase64 string) (string, error) {
	ciphertextBlob, err := base64.StdEncoding.DecodeString(encryptedBase64)
	if err != nil {
		return "", err
	}

	input := &kms.DecryptInput{
		CiphertextBlob: ciphertextBlob,
	}

	result, err := client.Decrypt(context.Background(), input)
	if err != nil {
		return "", err
	}

	return string(result.Plaintext), nil
}

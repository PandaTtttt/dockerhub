#!/bin/bash

# 有异常，则立即退出
set -e

# 开启 go mod 特性
export GO111MODULE=on
export CGO_ENABLED=0
# 交叉编译成 linux 二进制文件
export GOOS=linux
export GOARCH=amd64
BASE_DIR=$(cd "$(dirname "$0")"; pwd)
DOCKERFILE_DIR=${BASE_DIR}
DOCKER_IMG_PREFIX="q641287441a"
VERSION="1.1.0"

# 当前需要编译的服务
SERVERS=(airflow-jdk8)

CURRENT_SERVICE="airflow-jdk8"

# 镜像构建
dockerBuild(){
    echo ${DOCKERFILE_DIR}/${CURRENT_SERVICE}/Dockerfile
    if [[ -f ${DOCKERFILE_DIR}/${CURRENT_SERVICE}/Dockerfile ]];then
        echo docker building version: latest
        docker build -t ${DOCKER_IMG_PREFIX}/${CURRENT_SERVICE}:latest -f ${DOCKERFILE_DIR}/${CURRENT_SERVICE}/Dockerfile ${BASE_DIR}
        docker tag ${DOCKER_IMG_PREFIX}/${CURRENT_SERVICE}:latest ${DOCKER_IMG_PREFIX}/${CURRENT_SERVICE}:${VERSION}
    fi
}

# 推送本地编译好的镜像至仓库中
pushImage(){
    if [[ -f ${DOCKERFILE_DIR}/${CURRENT_SERVICE}/Dockerfile ]];then
        if [[ `docker images | grep ${DOCKER_IMG_PREFIX}/${CURRENT_SERVICE}| grep latest | wc -l` -eq 1 ]]; then
            docker push ${DOCKER_IMG_PREFIX}/${CURRENT_SERVICE}:latest
            docker push ${DOCKER_IMG_PREFIX}/${CURRENT_SERVICE}:${VERSION}
            docker rmi ${DOCKER_IMG_PREFIX}/${CURRENT_SERVICE}:${VERSION}
        fi
    fi
}

# 更新接口文档

case $1 in
 deploy)
        echo ${BASE_DIR}
        for CURRENT_SERVICE in ${SERVERS[*]}
        do
            dockerBuild
            pushImage
        done
        ;;
 buildimage)

        for CURRENT_SERVICE in ${SERVERS[*]}
        do
            dockerBuild
        done
        ;;
 pushimage)
        for CURRENT_SERVICE in ${SERVERS[*]}
        do
            pushImage
        done
        ;;
 *)
        echo "Usage: $0 [ deploy | buildimage | pushimage ]"
        exit 1
        ;;
esac

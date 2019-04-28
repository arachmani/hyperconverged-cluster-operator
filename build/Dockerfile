FROM golang:1.10 AS builder
ENV GOPATH=/go
WORKDIR /go/src/github.com/kubevirt/hyperconverged-cluster-operator/
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o /hyperconverged-cluster-operator github.com/kubevirt/hyperconverged-cluster-operator/cmd/manager

FROM centos:centos7
ENV OPERATOR=/usr/local/bin/hyperconverged-cluster-operator \
    USER_UID=1001 \
    USER_NAME=hyperconverged-cluster-operator
RUN \
    yum -y update \
    yum clean all
COPY --from=builder /go/src/github.com/kubevirt/hyperconverged-cluster-operator/build/bin/ /usr/local/bin
RUN /usr/local/bin/user_setup
COPY --from=builder /hyperconverged-cluster-operator $OPERATOR
ENTRYPOINT ["/usr/local/bin/entrypoint"]
USER ${USER_UID}

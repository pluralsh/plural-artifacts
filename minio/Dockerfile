FROM bitnami/kubectl:1.24.2

USER root

RUN wget https://github.com/minio/directpv/releases/download/v3.0.2/kubectl-directpv_3.0.2_linux_amd64 \
    && mv kubectl-directpv_3.0.2_linux_amd64 /opt/bitnami/kubectl/bin/kubectl-directpv \
    && chmod +x /opt/bitnami/kubectl/bin/kubectl-directpv \
    && chmod g+rwX /opt/bitnami

RUN mkdir /.direct-csi \
    && chmod g+rwX /.direct-csi

USER 1001

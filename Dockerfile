FROM archlinux/base
USER root

COPY build_script.sh / build_script.sh
RUN bash ./build_script.sh

FROM ubuntu:rolling
RUN apt update -qq && apt install -yy --no-install-recommends \
	    gcc-powerpc64-linux-gnu xz-utils git make ca-certificates gcc libssl-dev libc6-dev ccache \
	    && rm -rf /var/cache/archive
#RUN adduser --gecos "" --disabled-password ubuntu
#USER ubuntu
COPY driver.sh /usr/local/bin
ENTRYPOINT ["driver.sh"]

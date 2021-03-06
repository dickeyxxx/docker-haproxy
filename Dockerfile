FROM dickeyxxx/base
MAINTAINER Jeff Dickey jeff@dickeyxxx.com

RUN apt-get install -y build-essential make g++ libssl-dev

# Install haproxy
RUN mkdir -p /tmp/haproxy
WORKDIR /tmp/haproxy
RUN curl http://haproxy.1wt.eu/download/1.5/src/devel/haproxy-1.5-dev21.tar.gz -O
RUN tar -xzf haproxy-1.5-dev21.tar.gz
WORKDIR /tmp/haproxy/haproxy-1.5-dev21
RUN make TARGET=linux2628
RUN make install

# Configure
RUN mkdir /etc/haproxy
ADD haproxy.cfg  /etc/haproxy/haproxy.cfg
ADD cert.pem /etc/ssl/cert.pem

# Clean up
WORKDIR /
RUN rm -rf /tmp/haproxy
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD run /usr/local/bin/haproxy

CMD ["/usr/local/bin/haproxy"]

EXPOSE 80 443 220002

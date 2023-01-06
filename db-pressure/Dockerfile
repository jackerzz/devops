FROM ubuntu:xenial as builder
RUN apt-get update
RUN \
  DEBIAN_FRONTEND=noninteractive \
  apt-get install -y \
    build-essential autoconf automake libpcre3-dev libevent-dev \
    pkg-config zlib1g-dev libssl-dev libboost-all-dev cmake flex
COPY memtier_benchmark/ /memtier_benchmark
WORKDIR /memtier_benchmark
RUN autoreconf -ivf && ./configure && make && make install

FROM ubuntu:xenial
LABEL Description="memtier_benchmark"
COPY --from=builder /usr/local/bin/memtier_benchmark /usr/local/bin/memtier_benchmark

# sysbench
RUN apt-get update
RUN apt-get -y install make automake libtool pkg-config libaio-dev git
# For MySQL support
RUN apt-get -y install libmysqlclient-dev libssl-dev
# For PostgreSQL support
RUN apt-get -y install libpq-dev
RUN apt-get install -y --no-install-recommends vim

# memtier_benchmark
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends libevent-dev

COPY sysbench/ /sysbench
WORKDIR sysbench
RUN ./autogen.sh
RUN ./configure --with-mysql --with-pgsql
RUN make -j
RUN make install

WORKDIR /root
COPY memtier_benchmark/ /memtier_benchmark
COPY sysbench.sh /sysbench.sh
COPY pgbench.sh /pgbench.sh
COPY memtier_benchmark.sh /memtier_benchmark.sh
RUN apt-get clean && rm -rf /var/lib/apt/lists/

CMD ["bash"]


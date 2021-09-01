FROM krallin/centos-tini:7
#FROM centos:7
MAINTAINER Michael J. Stealey <stealey@renci.org>

ENV SLURM_VERSION=21.08.0 \
  MUNGE_UID=981 \
  SLURM_UID=982 \
  WORKER_UID=1000

ENV container docker

RUN yum -y update; yum clean all
RUN yum -y install systemd; yum clean all; \
(cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

RUN groupadd -g $MUNGE_UID munge \
  && useradd  -m -c "MUNGE Uid 'N' Gid Emporium" -d /var/lib/munge -u $MUNGE_UID -g munge  -s /sbin/nologin munge \
  && groupadd -g $SLURM_UID slurm \
  && useradd  -m -c "Slurm workload manager" -d /var/lib/slurm -u $SLURM_UID -g slurm  -s /bin/bash slurm \
  && groupadd -g $WORKER_UID worker \
  && useradd  -m -c "Workflow user" -d /home/worker -u $WORKER_UID -g worker  -s /bin/bash worker

# install packages for general functionality
RUN yum -y install \
  epel-release \
  && yum -y install \
  sudo \
  wget \
  which \
  tree \
  mariadb-server \
  mariadb-devel \
  munge \
  munge-libs \
  munge-devel \
  openssh-server \
  python3 \
  openssh-clients \
  libjwt \
  make \
  git

# install slurm 21.08.0
COPY rpms /packages
# /usr/bin/mpiexec from slurm-torque conflicts with openmpi install
WORKDIR /packages
RUN yum -y localinstall $(ls | grep -v -e 'torque' -e 'openmpi')
WORKDIR /

VOLUME ["/home", "/.secret", "/sys/fs/cgroup"]

#   22:         SSH
# 3306:         MariaDB
# 6817:         Slurm Ctl D
# 6818:         Slurm D
# 6819:         Slurm DBD
# 6820:         Slurm rest
EXPOSE 22 3306 6817 6818 6819 6820
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN yum install -y autofs
RUN systemctl enable autofs
ENTRYPOINT ["/usr/sbin/init", "--", "/docker-entrypoint.sh"]
#RUN mkdir /run/systemd/system
#CMD ["/usr/sbin/init"]
#CMD ["/usr/lib/systemd/systemd --system &"]
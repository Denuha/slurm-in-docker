FROM krallin/centos-tini:7
#FROM centos:7
MAINTAINER Michael J. Stealey <stealey@renci.org>

ENV SLURM_VERSION=20.11.8 \
  MUNGE_UID=981 \
  SLURM_UID=982 \
  WORKER_UID=1000

ENV container docker

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

# install slurm 20.11.8
RUN yum install -y slurm-${SLURM_VERSION} \
      slurm-slurmctld-${SLURM_VERSION} \
      slurm-slurmd-${SLURM_VERSION} \
      slurm-slurmrestd-${SLURM_VERSION} \
      slurm-slurmdbd-${SLURM_VERSION}
# /usr/bin/mpiexec from slurm-torque conflicts with openmpi install
WORKDIR /packages
WORKDIR /

VOLUME ["/home", "/.secret", "/sys/fs/cgroup"]

#   22:         SSH
# 3306:         MariaDB
# 6817:         Slurm Ctl D
# 6818:         Slurm D
# 6819:         Slurm DBD
# 6820:         Slurm rest
EXPOSE 22 3306 6817 6818 6819 6820
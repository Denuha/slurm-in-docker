#!/usr/bin/env bash
set -e

# building mpi 
MPI_VERSION=4.1.0
curl -O https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-${MPI_VERSION}-1.src.rpm

rpmbuild --rebuild --clean  \
            --define 'install_in_opt 1' \
            --define 'install_modulefile 1'  \
            --define 'build_all_in_one_rpm 0' \
            --define 'modulefile_path /etc/modulefiles' \
            --define 'modulefile_subdir mpi' \
            openmpi-${MPI_VERSION}-1.src.rpm

cp /root/rpmbuild/RPMS/x86_64/openmpi-* /packages

exec "$@"

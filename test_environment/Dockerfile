FROM ubuntu:20.04

RUN apt-get update
RUN apt-get install -y nano rdiff-backup
RUN echo "Installed $(rdiff-backup --version)"

# supposse the root user has also a home directory
COPY example_data/ /home/root/

ARG SCRIPT=backup.sh
COPY $SCRIPT /home/root/

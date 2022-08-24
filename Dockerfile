FROM python:3.9-slim-buster
RUN apt update -y
RUN apt install -y wget
COPY . /opt/
RUN cd /opt/ \
        && wget https://github.com/soedinglab/MMseqs2/releases/download/13-45111/mmseqs-linux-avx2.tar.gz \
        && tar -xf mmseqs-linux-avx2.tar.gz \
        && rm mmseqs-linux-avx2.tar.gz \
	&& cd complet-plus-scripts \
	&& cp completplus.sh completplus \
	&& chmod +x completplus

ENV PATH=/opt/mmseqs/bin:/opt/complet-plus-scripts:$PATH
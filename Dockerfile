FROM python
COPY . /migrator
RUN pip3 install -r /migrator/requirements.txt

RUN apt update && apt install -y --no-install-recommends mariadb-client \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


CMD /migrator/start.sh

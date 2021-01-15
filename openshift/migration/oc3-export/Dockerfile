FROM python:3.8

WORKDIR /src
COPY ./requirements.txt ./
RUN pip install -r requirements.txt
#ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["/bin/bash", "./oc3-export.sh"]

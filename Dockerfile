FROM django:latest

MAINTAINER Samuel Kurath <skurath@hsr.ch>

EXPOSE 8000

RUN apt-get update \
&& apt-get install -y nginx python-pip python-dev git vim \
&& pip install --upgrade pip \
&& pip3 install --upgrade tensorflow \
&& pip install uwsgi \
&& pip install pillow \
&& cd / \
&& git clone https://github.com/Murthy10/tira.git \
&& ln -s /tira/tira/docker/tira_nginx.conf /etc/nginx/sites-enabled/ \
&& cd /tira/ \
&& echo 'yes' | python manage.py collectstatic \
&& rm db.sqlite3 \
&& python manage.py makemigrations recognition \
&& python manage.py migrate 

ADD graph.pb .
ADD labels.txt .

RUN rm -f /tira/tira/apps/recognition/graph/graph.pb
RUN rm -f /tira/tira/apps/recognition/graph/labels.txt
RUN mv graph.pb /tira/tira/apps/recognition/graph/
RUN mv labels.txt /tira/tira/apps/recognition/graph/

RUN chmod +x /tira/tira/docker/start.sh

CMD ["/tira/tira/docker/start.sh"]

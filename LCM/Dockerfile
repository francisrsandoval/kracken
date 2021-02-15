FROM python:3.9-buster

RUN mkdir -p /usr/src/app/python-flask-server-generated
WORKDIR /usr/src/app/python-flask-server-generated

COPY python-flask-server-generated/requirements.txt /usr/src/app/python-flask-server-generated

RUN pip3 install --no-cache-dir -r requirements.txt

# install azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Terrraform doesn't like this
#RUN az login --service-principal -u http://os-sp -p pyfJpfdEyWaByF9jpTlqlc5OuD.NjDyH39 --tenant 85466a9f-3bee-471b-8220-50272f30c416
# or this
# az login -u frank@pajaritotech.com -p msFijisan1*

# and Azure doesn't like this
#RUN az login -u frank@pajaritotech.com -p msFijisan1*

# login manually after startup

# forward request and error logs to docker log collector (doesn't seem to work)
RUN ln -sf /dev/stdout /var/log/access.log \
    && ln -sf /dev/stderr /var/log/error.log

ENV TFDIR=/usr/src/app/terraform

# install terraform
RUN wget https://releases.hashicorp.com/terraform/0.14.5/terraform_0.14.5_linux_amd64.zip
RUN unzip terraform_0.14.5_linux_amd64.zip && rm terraform_0.14.5_linux_amd64.zip
RUN mv terraform /usr/bin/terraform

COPY . /usr/src/app

EXPOSE 8080

# need to enter into shell and login into azure

#ENTRYPOINT ["python3"]

#CMD ["-m", "swagger_server"]

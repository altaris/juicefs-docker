IMAGE 	= juicefs-docker
SUDO 	= sudo
USER 	= altaris

build:
	$(SUDO) docker build -t $(USER)/$(IMAGE) .

push:
	-$(SUDO) docker push $(USER)/$(IMAGE)

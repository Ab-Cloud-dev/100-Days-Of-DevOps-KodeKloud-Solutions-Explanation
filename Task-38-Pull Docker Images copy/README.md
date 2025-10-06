Nautilus project developers are planning to start testing on a new project. As per their meeting with the DevOps team, they want to test containerized environment application features. As per details shared with DevOps team, we need to accomplish the following task:

a. Pull `busybox:musl` image on `App Server 2` in Stratos DC and re-tag (create new tag) this image as `busybox:blog`.

---

# Solution: 
```
[steve@stapp02 ~]$ docker pull busybox:musl

musl: Pulling from library/busybox
8e7bef4a92af: Pull complete 
Digest: sha256:254e6134b1bf813b34e920bc4235864a54079057d51ae6db9a4f2328f261c2ad
Status: Downloaded newer image for busybox:musl
docker.io/library/busybox:musl

[steve@stapp02 ~]$ docker images

REPOSITORY   TAG       IMAGE ID       CREATED         SIZE
busybox      musl      44f1048931f5   11 months ago   1.46MB

[steve@stapp02 ~]$ docker tag busybox:musl busybox:blog

[steve@stapp02 ~]$ docker images

REPOSITORY   TAG       IMAGE ID       CREATED         SIZE
busybox      blog      44f1048931f5   11 months ago   1.46MB
busybox      musl      44f1048931f5   11 months ago   1.46MB

```




## Retag the Docker Image.
After pulling the image, you can assign a new tag to it using the docker tag command. This command creates an alias or a new reference to an existing image. The original image and its tag will still exist unless explicitly removed.
Code

    docker tag <source_image>:<source_tag> <new_image_name>:<new_tag>
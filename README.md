# Context

This is a dockerized python app that copies files from an SFTP to an Azure File Share disk. This can be used with cronjobs to create backups.

# Data Needed

### _SFTP:_

| Data          | Description                                 |
| ------------- | ------------------------------------------- |
| SFTP_HOSTNAME | Name of the host.                           |
| SFTP_USERNAME | Username used to connect to the FTP server. |
| SFTP_PASSWORD | Password of the user.                       |
| SFTP_PORT     | Port of the SFTP server.                    |

---

### _AFS_:

| Data          | Description                                                |
| ------------- | ---------------------------------------------------------- |
| AFS_ACCOUNT   | Name of the Azure storage account where the AFS is stored. |
| AFS_KEY       | Key of the Azure storage account.                          |
| AFS_CONTAINER | File Share disk where you want to backup the files on.     |

# Example of how to build and run the docker container

## Build the docker image

```bash
docker build -t backup:latest .
```

## Run the docker image:

```bash
docker run --cap-add=SYS_ADMIN --cap-add=DAC_READ_SEARCH --network host -e SFTP_HOSTNAME=127.0.0.1 -e SFTP_USERNAME=stfp-username -e SFTP_PASSWORD=stfp-user-pass -e SFTP_PORT=22 -e AFS_ACCOUNT=Azure-storage-account -e AFS_KEY=Azure-account-key -e AFS_CONTAINER=container backup:latest
```

- note that `--cap-add=SYS_ADMIN --cap-add=DAC_READ_SEARCH` arguments are needed since this gives permisions to mount the AFS disk inside de docker container.
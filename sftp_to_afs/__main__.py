import os
from sftp_to_afs.client.sftp_client import SftpClient

hostname = os.getenv("SFTP_HOSTNAME")
username = os.getenv("SFTP_USERNAME")
password = os.getenv("SFTP_PASSWORD")
port = os.getenv("SFTP_PORT")

# from the sftp path to the local path, AFS path in this case
from_to = [("/files", "/mnt/azurefileshare/files")]


def main() -> None:
    if (hostname and username and password and port):
        try:
            client = SftpClient(hostname, username, password, int(port))
            for path in from_to:
                client.download_files(path[0], path[1])
        finally:
            client.client.close


if __name__ == '__main__':
    main()

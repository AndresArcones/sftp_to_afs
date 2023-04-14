import os
from os.path import isfile, join
from paramiko import Transport, SFTPClient
from stat import S_ISREG, S_ISDIR
from sftp_to_afs.logger.logger import Logger
from sftp_to_afs.utils.set import insert_in_set


class SftpClient:
    client: SFTPClient
    logger: Logger

    def __init__(self, hostname: str, username: str, password: str,
                 port: int) -> None:
        # connect to the SFTP server
        transport = Transport((hostname, port))
        transport.default_window_size = 4294967294
        transport.packetizer.REKEY_BYTES = pow(2, 40)
        transport.packetizer.REKEY_PACKETS = pow(2, 40)
        transport.connect(username=username, password=password)

        # assign an SFTP client object
        client = SFTPClient.from_transport(transport)
        if client:
            self.client = client

        # initialices logger
        self.logger = Logger()

    def download_files(self, remote_path: str, local_path: str) -> None:
        files_downloaded = False

        if not self.client:
            raise Exception("sftp client can't be 'None'")

        # get a list of the files in the remote directory (It can be files or directories)
        remote_file_list = [file for file in self.client.listdir_attr(remote_path)]

        if remote_file_list:
            # create the local directory if not present
            if not os.path.exists(local_path):
                os.makedirs(local_path)

            # get a list of the files in the local directory
            local_file_list = set([f for f in os.listdir(local_path)
                                   if isfile(join(local_path, f))])

            for file in remote_file_list:
                # if not yet in local directory download the file
                if file.st_mode and S_ISREG(file.st_mode) and insert_in_set(
                        local_file_list, file.filename):

                    remote_file = os.path.join(remote_path, file.filename)
                    local_file = os.path.join(local_path, file.filename)
                    self.client.get(remote_file, local_file)

                    files_downloaded = True

                    log = f"Copied '{file.filename}' from '{remote_path}' to '{local_path}'."  # noqa
                    self.logger.info(log)
                    print(log)

                elif file.st_mode and S_ISDIR(file.st_mode):
                    self.download_files(
                        os.path.join(
                            remote_path, file.filename),
                        os.path.join(
                            local_path, file.filename)
                    )

        # log when no files are downloaded because already present in the local
        if not files_downloaded:
            log = f"No files needed to be copied from '{remote_path}' to '{local_path}'."

            self.logger.info(log)
            print(log)

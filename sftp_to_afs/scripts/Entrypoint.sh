#!/bin/bash

################ retrieve env variables ####################

AZURE_ACCOUNT_USER=$AFS_ACCOUNT
AZURE_ACCOUNT_PASS=$AFS_KEY
AZURE_ACCOUNT_CONTAINER=$AFS_CONTAINER

################# atach Azure File Share container ###############################

MOUNT_DIR=/mnt/azurefileshare
CREDENTIALS_DIR=/etc/smbcredentials
CREDENTIALS_FILE=${AZURE_ACCOUNT_USER}.cred
CREDENTIALS=${CREDENTIALS_DIR}/${CREDENTIALS_FILE}

if [ ! -d $MOUNT_DIR ]; then
    mkdir $MOUNT_DIR
fi

if [ ! -d $CREDENTIALS_DIR ]; then
    mkdir $CREDENTIALS_DIR
fi

if [ ! -f "${CREDENTIALS}" ]; then
    bash -c "echo 'username=${AZURE_ACCOUNT_USER}' >> ${CREDENTIALS}"
    bash -c "echo 'password=${AZURE_ACCOUNT_PASS}' >> ${CREDENTIALS}"
fi

chmod 600 "${CREDENTIALS}"

bash -c "echo '//${AZURE_ACCOUNT_USER}.file.core.windows.net/${AZURE_ACCOUNT_CONTAINER} ${MOUNT_DIR} cifs nofail,credentials=${CREDENTIALS},dir_mode=0777,file_mode=0777,serverino,nosharesock,actimeo=30' >> /etc/fstab"
mount -t cifs "//${AZURE_ACCOUNT_USER}.file.core.windows.net/${AZURE_ACCOUNT_CONTAINER}" "${MOUNT_DIR}" -o credentials="${CREDENTIALS}",dir_mode=0777,file_mode=0777,serverino,nosharesock,actimeo=30

################# Run the backup task ###############################

poetry run python -m sftp_to_afs

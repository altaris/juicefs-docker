#!/bin/sh

export AWS_REGION="$S3_REGION"
export JFS_RSA_PASSPHRASE
export META_PASSWORD

_format() {
    echo "FORMATTING NEW JUICEFS FILESYSTEM '$FS_NAME' IN '$S3_BUCKET'"
    juicefs format                              \
        --storage s3                            \
        --bucket "$S3_BUCKET"                   \
        --access-key "$S3_ACCESS_KEY"           \
        --secret-key "$S3_SECRET_KEY"           \
        --encrypt-rsa-key "cert/${FS_NAME}.pem" \
        "$META_URI" "$FS_NAME"
}

_mount() {
    echo "MOUNTING JUICEFS FILESYSTEM '$FS_NAME' FROM '$S3_BUCKET'"
    juicefs mount           \
        --background        \
        --cache-dir /cache  \
        --cache-size 512    \
        "$META_URI" "/mnt/$FS_NAME"
}

_umount() {
    echo "UNMOUNTING JUICEFS FILESYSTEM '$FS_NAME'"
    juicefs umount "/mnt/$FS_NAME"
}

trap _umount SIGTERM SIGINT SIGQUIT SIGHUP ERR
juicefs status "$META_URI" || _format
_mount || exit
tail -f /dev/null & wait

../configs/ssh_key-gen.sh
#docker build --no-cache -t lab_host .
docker build -t lab_host .
rm -f id_rsa* authorized_keys
rm -f ../image/id_rsa*
rm -f ../image/authorized_keys

ssh-keygen -t rsa -q -f ../image/id_rsa -N ""
cat ../image/id_rsa.pub > ../image/authorized_keys
cat $HOME/.ssh/id_rsa.pub >> ../image/authorized_keys
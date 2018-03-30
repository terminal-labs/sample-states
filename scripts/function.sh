function saltmaster { # $1 = location, e.g. 'master' or '*', $2 = command
    start="su saltmaster -c \"cd /home/saltmaster;\
     source salt_venv/bin/activate;\
     python /home/saltmaster/salt_src/scripts/salt '"
    middle="' -c /home/saltmaster/salt_controlplane/etc/salt "
    end=" \""
    command=$start$1$middle$2$end
    eval $command
}

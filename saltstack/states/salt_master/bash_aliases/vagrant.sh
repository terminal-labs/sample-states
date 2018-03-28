#!/usr/bin/env bash
alias inflation-env="sudo su saltmaster"

function inflation-salt-call-local { # $1 = location, e.g. 'master' or '*', $2 = command
    start="sudo salt-call "
    middle=" "
    command=$start$middle$1
    eval $command
}


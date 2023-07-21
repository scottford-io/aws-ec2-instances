#!/bin/bash
bash -c "$(curl -sSL https://install.mondoo.com/sh)"
cnspec login --token ${mondoo_registration_token} --config /etc/opt/mondoo/mondoo.yml
cnspec scan local --config /etc/opt/mondoo/mondoo.yml

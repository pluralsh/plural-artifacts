#!/bin/bash

default='[
    {
        "matchDatasources": [
        "docker"
        ],
        "matchUpdateTypes": [
        "major"
        ],
        "enabled": true
    },
    {
        "matchDatasources":["helm"],
        "postUpgradeTasks": {
        "commands": [
            "helm dependency update {{{packageFileDir}}}"
        ],
        "fileFilters": ["**/*.tgz"]
        }
    },
    {
        "description": "Disable major update k8s client-go",
        "matchPackagePatterns": ["^k8s.io/client-go"],
        "matchUpdateTypes": ["major"],
        "enabled": false
    },
    {
        "description": "Bump helm chart versions",
        "matchManagers": ["helmv3"],
        "bumpVersion": "patch"
    }
]'

base=$(jq ".packageRules |= ${default}" renovate.json)
sum=$(echo $base)

for dir in $(echo */ | sed 's/\///g'); do

    sum=$(echo $sum | jq ".packageRules |= .+ [{\"description\": \"Group $dir Helm updates\", \"matchFileNames\": [\"$dir/**\"], \"matchManagers\": [\"helm-requirements\", \"helm-values\", \"helmfile\", \"helmsman\", \"helmv3\"], \"groupName\": \"$dir\", \"additionalBranchPrefix\": \"\"}]")

done
echo $sum | jq > renovate.json

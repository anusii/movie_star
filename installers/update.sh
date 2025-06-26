#!/bin/bash

# 20241024 gjw After a github action has built the bundles and stored
# them as artefacts on github, we can upload them to solidcommunity.au for
# distribution.

APP=moviestar

HOST=solidcommunity.au
FLDR=/var/www/html/installers/
DEST=${HOST}:${FLDR}

# From the recent 'Build Installers' workflows, identify the 'Bump
# version' pushes to the repository and get the latest one as the one
# we want to download the artefacts.

bumpId=$(gh run list --limit 100 --json databaseId,displayTitle,workflowName \
	     | jq -r '.[] | select(.workflowName | startswith("Build Installers")) | select(.displayTitle | startswith("Bump version")) | .databaseId' \
	     | head -n 1)

echo "github action id: $bumpId"

if [[ -z "${bumpId}" ]]; then
    echo "No workflow found."
    exit 1
fi

status=$(gh run view ${bumpId} --json status --jq '.status')
conclusion=$(gh run view ${bumpId} --json conclusion --jq '.conclusion')

# Only proceed if the latest action hase been completed successfully

# 20250611 gjw Currently failing:
#
# gh run download ${bumpId} --name ${APP}-linux-zip
# error downloading moviestar-linux-zip: would result in path traversal
#
# I was then manually downloading through browser, unzip and move
# here, then run this script.
#
# But this should work as an alternative:
#
# gh api -H "Accept: application/vnd.github+json"   repos/anusii/moviestar/actions/artifacts/3300608315/zip >| artifact.zip
#
# Need to get the correct artifact ID for each artefact.

if [[ "${status}" == "completed" && "${conclusion}" == "success" ]]; then

    echo "Uploads are going to ${DEST}."
    echo

    # Determine the latest version from pubspec.yaml. Assumes the
    # latest Bump Version push is the same version.

    version=$(grep version ../pubspec.yaml | head -1 | cut -d ':' -f 2 | sed 's/ //g')

    echo '***** UPLOAD LINUX ZIP.'

    ## gh run download ${bumpId} --name ${APP}-linux-zip

    artifactId=$(gh api -H "Accept: application/vnd.github+json" /repos/anusii/moviestar/actions/artifacts \
		    --jq '.artifacts[] | select(.name=="moviestar-linux-zip") | .id' | head -n 1)
    echo "artifact id: $artifactId"
    gh api -H "Accept: application/vnd.github+json" repos/anusii/moviestar/actions/artifacts/${artifactId}/zip > artifact.zip
    unzip artifact.zip
    rm -f artifact.zip

    rsync -avzh ${APP}-dev-linux.zip ${DEST}
    mv -f ${APP}-dev-linux.zip ARCHIVE/${APP}_${version}_linux.zip

    echo ""

    echo '***** UPLOAD WINDOWS INNO'

    ## gh run download ${bumpId} --name ${APP}-windows-inno

    artifactId=$(gh api -H "Accept: application/vnd.github+json" /repos/anusii/moviestar/actions/artifacts \
		    --jq '.artifacts[] | select(.name=="moviestar-windows-inno") | .id' | head -n 1)
    echo "artifact id: $artifactId"
    gh api -H "Accept: application/vnd.github+json" repos/anusii/moviestar/actions/artifacts/${artifactId}/zip > artifact.zip
    unzip artifact.zip
    rm -f artifact.zip

    rsync -avzh ${APP}-dev-windows-inno.exe ${DEST}
    mv ${APP}-dev-windows-inno.exe ARCHIVE/${APP}_${version}_windows-inno.exe

    echo ""

    echo '***** UPLOAD WINDOWS ZIP'

    ## gh run download ${bumpId} --name ${APP}-windows-zip

    artifactId=$(gh api -H "Accept: application/vnd.github+json" /repos/anusii/moviestar/actions/artifacts \
		    --jq '.artifacts[] | select(.name=="moviestar-windows-zip") | .id' | head -n 1)
    echo "artifact id: $artifactId"
    gh api -H "Accept: application/vnd.github+json" repos/anusii/moviestar/actions/artifacts/${artifactId}/zip > artifact.zip
    unzip artifact.zip
    rm -f artifact.zip

    rsync -avzh ${APP}-dev-windows.zip ${DEST}
    mv -f ${APP}-dev-windows.zip ARCHIVE/${APP}_${version}_windows.zip
    ssh ${HOST} "cd ${FLDR}; chmod a+r ${APP}-dev-*.zip ${APP}-dev-*.exe"


    echo ""

    echo '***** UPLOAD MACOS'

    ## gh run download ${bumpId} --name ${APP}-macos-zip

    artifactId=$(gh api -H "Accept: application/vnd.github+json" /repos/anusii/moviestar/actions/artifacts \
		    --jq '.artifacts[] | select(.name=="moviestar-macos-zip") | .id' | head -n 1)
    echo "artifact id: $artifactId"
    gh api -H "Accept: application/vnd.github+json" repos/anusii/moviestar/actions/artifacts/${artifactId}/zip > artifact.zip
    unzip artifact.zip
    rm -f artifact.zip

    rsync -avzh ${APP}-dev-macos.zip ${DEST}
    mv ${APP}-dev-macos.zip ARCHIVE/${APP}_${version}_macos.zip
    ssh ${HOST} "cd ${FLDR}; chmod a+r ${APP}-dev-*.zip ${APP}-dev-*.exe"

else
    gh run view ${bumpId}
    gh run view ${bumpId} --json status,conclusion
    echo ''
    echo "***** Latest github actions has not successfully completed. Exiting."
    echo ''
    exit 1
fi

set -e -u -o pipefail

declare PROJECT_NAME="labs-infra"
declare WORKSPACE_TYPE=""

help() {
  cat <<-EOF

  This command lists all the users for whom a codeready workspace is up and running

  Usage:
      codeready-workspace-users [options]
  
  Example:
      codeready-workspace-users -p labs-infra -t quarkus-tools

  OPTIONS:
      -p|--project                   Name of the project, defaults to 'labs-infra'
      -t|--workspace-type            [REQUIRED] Name of the type of code ready workspace pod (e.g. quarkus-tools)
EOF

}

while (( "$#" )); do
    case "$1" in
        -p|--project)
            PROJECT_NAME=$2
            shift 2
            ;;
        -t|--workspace-type)
            WORKSPACE_TYPE=$2
            shift 2
            ;;
        -*|--*)
            echo "Error: Unsupported flag $1"
            help
            exit 1
            ;;
        *) 
            break
    esac
done

if [[ -z "${WORKSPACE_TYPE}" ]]; then
    help
    exit 1
fi

# look for the config map suffixed by -gitconfig for all running workspace pods
for WORKSPACE in $(oc get pods -n $PROJECT_NAME | grep ${WORKSPACE_TYPE} | grep Running | cut -f 1 -d " " | cut -f 1 -d .); do
    oc describe cm "${WORKSPACE-gitconfig}" -n "${PROJECT_NAME}" | grep "name ="
done


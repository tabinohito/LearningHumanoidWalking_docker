set -x
GIT_USERNAME=`git config user.name`
GIT_USEREMAIL=`git config user.email`
GIT_SSHKEY=~/.ssh/id_rsa

SUDO_STRING=`groups|grep docker`
SUDO=""
if [ -z "$SUDO_STRING" ]; then
  SUDO="sudo "
fi

while [[ $# -gt 0 ]]; do
    case $1 in
        -u|--user)
            GIT_USERNAME="$2"
            shift
            shift
            ;;
        -e|--email)
            GIT_USEREMAIL="$2"
            shift
            shift
            ;;
        --help)
            echo "build.sh [--user GIT_USERNAME][--email GIT_EMAIL]"
            exit 0
            ;;
        --)
            shift
            break
            ;;
        -*|--*)
            echo "Unknown option $1"
            exit 1
            ;;
        *)
            POSITIONAL_ARGS+=("$1") # save positional arg
            shift # past argument
            ;;
    esac
done

DOCKER_BUILDKIT=1 $SUDO docker build \
    --build-arg GIT_USERNAME="$GIT_USERNAME" \
    --build-arg GIT_USEREMAIL="$GIT_USEREMAIL" \
    --ssh default=$GIT_SSHKEY \
    -t lerning_humanoid_walking:ubuntu20.04 .
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' #No Color

name=$(docker ps -a | grep -o japcpage)

if [ ! -z "$name" ]
then 
    echo -e "${RED}REMOVING CONTAINER:${NC} japcpage"
    if [ -z "$(docker rm $name)" ]
    then
        echo "PROCEED"
    fi
fi

echo -e "${BLUE}LAUNCHING CONTAINER:${NC} japcpage"
    $(docker run --name japcpage -it -p 80:80 japc /bin/bash) #source /home/app/japc_venv/bin/activate)
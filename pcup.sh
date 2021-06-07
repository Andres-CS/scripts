# ---- PRE DEFINE FUNCTION ---- 

function updateUbuntu(){
   sudo apt-get update -y
}

function updateOpensuse(){
    sudo zypper update -y
}

function updateRPM(){
    sudo pacman update -y
}


function pcup(){

    case $1 in

    "DEBIAN" | "UBUNTU")
        updateUbuntu
    ;;
    "OPENSUSE")
        updateOpensuse
    ;;
    "RED HAT")
        updateRPM
    ;;
    *)
        echo "DISTRO NOT RECOGNIZED"
    ;;
    esac
}

# -----------------------------

function getDistro(){
    echo `cat /etc/os-release | grep ID_LIKE=[A-Za-z] | cut -d = -f 2 | tr '[:lower:]' '[:upper:]'`
}

d=`getDistro`


pcup $d

<<Block_comment
distros=("DEBIAN" "OPENSUSE" "RED HAT" "UBUNTU")

for id in "${distros[@]}"
do
    #echo $id
    if [ $d == "$id" ]
    then
        echo $id $d
        break
    fi
done
Block_comment
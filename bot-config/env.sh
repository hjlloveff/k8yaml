# PS: use fenv source env.sh if you're using fish shell

# All flags should have DEVENV as prefix to avoid
# naming conflict

# DEVENV_ROOT can be used to identify if the ENVs are exported
export DEVENV_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export DEVENV_ROOT_MODULE=$DEVENV_ROOT/modules
export DEVENV_ROOT_DOCKER_BUILD=$DEVENV_ROOT/deploy/docker_build
export DEVENV_ROOT_BIN=$DEVENV_ROOT/bin
export DEVENV_ROOT_VENDORS=$DEVENV_ROOT/vendors

HOME_PATH=/home/deployer
export EMOTIBOT_INFRASTRUCTURE_ROOT=$HOME_PATH/infrastructure
export EMOTIBOT_INFRASTRUCTURE_VOLUME=$EMOTIBOT_INFRASTRUCTURE_ROOT/volumes


# Global settings
export DEVENV_DOCKER_REPO=docker-reg.emotibot.com.cn:55688
export DEVENV_DOCKER_REPO_MIRROR=bladetpe.emotibot.com.cn:55688

# Setup arcanist
export PATH=$PATH:$DEVENV_ROOT_BIN/arcanist/bin

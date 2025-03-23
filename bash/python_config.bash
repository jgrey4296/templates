# https://stackoverflow.com/questions/36365801/run-a-crontab-job-using-an-anaconda-env/60977676#60977676

with (){
    # simple command to simplify:
    # mamba run -n {} {}
    # into:
    # with {} {}
    env_name="$1"
    shift
    jgdebug "Env: $env_name Args: $@"
    mamba run -n "$env_name" "$@"
}

use (){
    # activate a mamba env
    env_name="$1"
    micromamba activate "$env_name"
}

init_py_env() {
    # initalise conda/mamba on entry to interactive shell
	jgdebug "Initialising Python"
    if [[ ! ( -L "${HOME}/.condarc" ) ]] && [[ ! ( -L "${HOME}/.mambarc" ) ]]; then
        echo "No Conda Setup file"
        return
    fi
    alias mamba="micromamba"

    if [[ -z "${CONDA_DEFAULT_ENV}" ]]; then
        CONDA_DEFAULT_ENV=""
    fi
    export MAMBA_EXE="${HOME}/.local/bin/micromamba";
    export MAMBA_ROOT_PREFIX="${BASE_CACHE}/mamba";
    __mamba_setup="$($MAMBA_EXE shell hook --shell bash --root-prefix $MAMBA_ROOT_PREFIX 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "${__mamba_setup}"
    fi
    unset __mamba_setup
}

setup_conda () {
    # for activating an environment
	jgdebug "Setting up Conda"
    if [[ -f ".venv" ]]; then
        ENV=$(tail -n 1 .venv)
        echo "Env Conda : ${ENV}"
    fi

    case "$OSTYPE" in
        linux*)
            if [[ ! ( -x "${MAMBA_EXE}" ) ]]; then
                echo "Mamba executable not found"
                return
            fi

            if [[ ! ( -d "${MAMBA_ROOT_PREFIX}" ) ]]; then
                echo "Mamba directory not found"
                return
            fi

            if [[ -n "${CONDA_DEFAULT_ENV}" ]] && [[ -n "${MAMBA_ROOT_PREFIX}" ]]; then
                echo "Mamba: ${MAMBA_ROOT_PREFIX} : ${CONDA_DEFAULT_ENV}"
                micromamba activate "${CONDA_DEFAULT_ENV}"
            fi
            ;;
    esac
}

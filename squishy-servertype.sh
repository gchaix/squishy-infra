# squishy detect server type environment and modify prompt

# Set the initial prompt.  Red prompt if user is root
if [[ ${EUID} == 0 ]] ; then
  PS1='\[\033[01;31m\]\h\[\033[01;34m\] \W \$\[\033[00m\] '
else
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]$ '
fi

# if $SERVERTYPE environment variable exists, use it.  Otherwise, guess based on hostname.
if [ -z "$SERVERTYPE" ]; then
  case `hostname` in
    *.local)
      SERVERTYPE="LOCAL"
      ;;
    *-dev*|*.private)
      SERVERTYPE="DEV"
      ;;
    *-stg*)
      SERVERTYPE="STAGING"
      ;;
    *-web*|*-db*)
      SERVERTYPE="PRODUCTION"
      ;;
    *)
      SERVERTYPE="PRODUCTION"
      ;;
  esac
fi

# set the prompt colors. Red for prod, yellow for staging, green for laptop/dev
PROMPT_COLOR=""
case "$SERVERTYPE" in
  PROD*)
    PROMPT_COLOR="\[\033[01;31m\]"
    ;;
  LAP*)
    PROMPT_COLOR="\[\033[01;32m\]"
    ;;
  DEV*)
    PROMPT_COLOR="\[\033[01;32m\]"
    ;;
  *)
    PROMPT_COLOR="\[\033[01;33m\]"
    ;;
esac

# generate the tag with servertype text
SQUISHY_PROMPT="$PROMPT_COLOR[ $SERVERTYPE ]\[\033[00m\] "

# Insert into the PS1 prompt
PS1="${SQUISHY_PROMPT}${PS1}"

# .bashrc

source $STARTUPDIR/generate_container_user

# Source global definitions
if [ -f ./.bashrc_user.sh ]; then
   echo "Executing user's ./.bashrc_user.sh"
   . ./.bashrc_user.sh
else
   echo "No ./.bashrc_user.sh file found - no customizations will be loaded."
fi


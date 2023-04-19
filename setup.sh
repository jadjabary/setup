#!/usr/bin/env bash
PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt:/opt/homebrew/bin

if ! command -v brew >/dev/null 2>&1; then
  echo "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Get the current user's home directory
  user_home=$(eval echo ~$(whoami))

  # Check for the Homebrew installation directory
  brew_path=""
  if [ -f "/opt/homebrew/bin/brew" ]; then
    brew_path="/opt/homebrew/bin/brew"
  elif [ -f "/usr/local/bin/brew" ]; then
    brew_path="/usr/local/bin/brew"
    # Add more conditions here for other possible Homebrew installation paths
  fi

  if [ -n "$brew_path" ]; then
    # Append the Homebrew setup command to .zprofile
    echo "exporting path to .zprofile"
    echo 'eval "$('"${brew_path}"' shellenv)"' >> "${user_home}/.zprofile"

    # Load Homebrew environment variables in the current session
    eval "$(${brew_path} shellenv)"
  else
    echo "Error: Homebrew installation directory not found."
    # Handle the error condition as needed
  fi
else
  echo "Updating Homebrew"
  brew update
fi

# Check if Git is installed
if ! command -v git >/dev/null 2>&1; then
  echo "Git is not installed. Installing now..."
  brew install git
else
  echo "Git is already installed"
fi

# Check if Oh My Zsh is installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Oh My Zsh is not installed. Installing now..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    echo "Oh My Zsh has been installed."
else
    echo "Oh My Zsh is already installed."
fi

# Check if powerlevel10k directory exists
if [ ! -d "$HOME/powerlevel10k" ]; then
    echo "powerlevel10k not found, cloning..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/powerlevel10k"
else
    echo "powerlevel10k already installed."
fi

# Check if powerlevel10k.zsh-theme is sourced in .zshrc
if ! grep -q "source ~/powerlevel10k/powerlevel10k.zsh-theme" "$HOME/.zshrc"; then
    echo "Adding powerlevel10k.zsh-theme to .zshrc"
    echo -e "\nsource ~/powerlevel10k/powerlevel10k.zsh-theme" >> "$HOME/.zshrc"
else
    echo "powerlevel10k.zsh-theme already sourced in .zshrc."
fi

# Update ZSH_THEME to powerlevel10k in .zshrc
if ! grep -q 'ZSH_THEME="powerlevel10k/powerlevel10k"' "$HOME/.zshrc"; then
    current_theme=$(grep 'ZSH_THEME=' "$HOME/.zshrc" | awk -F'"' '{print $2}')
    echo "Setting ZSH_THEME to powerlevel10k in .zshrc"
    sed -i '' 's/ZSH_THEME="'"$current_theme"'"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' "$HOME/.zshrc"
else
    echo "ZSH_THEME already set to powerlevel10k in .zshrc."
fi

# Set POWERLEVEL9K_INSTANT_PROMPT to true in .zshrc
if ! grep -q 'POWERLEVEL9K_INSTANT_PROMPT=true' "$HOME/.zshrc"; then
    echo "Setting POWERLEVEL9K_INSTANT_PROMPT to true in .zshrc"
    echo 'POWERLEVEL9K_INSTANT_PROMPT=true' >> "$HOME/.zshrc"
else
    echo "POWERLEVEL9K_INSTANT_PROMPT already set to true in .zshrc."
fi

# Check if zsh-syntax-highlighting directory exists in home directory
if [ ! -d "$HOME/zsh-syntax-highlighting" ]; then
    echo "zsh-syntax-highlighting not found, cloning..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/zsh-syntax-highlighting"
else
    echo "zsh-syntax-highlighting already installed."
fi

# Check if zsh-syntax-highlighting is sourced in .zshrc
# Check if zsh-syntax-highlighting is sourced in .zshrc
if ! grep -q "source ~/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" "$HOME/.zshrc"; then
    echo "Adding zsh-syntax-highlighting to .zshrc"
    echo -e "\nsource ~/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> "$HOME/.zshrc"
else
    echo "zsh-syntax-highlighting already sourced in .zshrc."
fi

# Check if zsh-autosuggestions directory exists in home directory
if [ ! -d "$HOME/.zsh/zsh-autosuggestions" ]; then
    echo "zsh-autosuggestions not found, cloning..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.zsh/zsh-autosuggestions"
else
    echo "zsh-autosuggestions already installed."
fi

# Check if zsh-autosuggestions is sourced in .zshrc
if ! grep -q "source \$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" "$HOME/.zshrc"; then
    echo "Adding zsh-autosuggestions to .zshrc"
    echo -e "\nsource \$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> "$HOME/.zshrc"
else
    echo "zsh-autosuggestions already sourced in .zshrc."
fi

# Define the function to be added to .zshrc
aws_unset_func='aws_unset () {
    unset AWS_SESSION_EXP
    unset AWS_DEFAULT_PROFILE
    unset AWS_SECRET_ACCESS_KEY
    unset AWS_SESSION_TOKEN
    unset AWS_ACCESS_KEY_ID
    unset AWS_OKTA_ASSUMED_ROLE_ARN  
    unset AWS_OKTA_MFA_PROVIDER
    unset AWS_OKTA_PROFILE
    unset AWS_OKTA_ASSUMED_ROLE
    unset AWS_SECURITY_TOKEN
    unset AWS_OKTA_SESSION_EXPIRATION
}'

# Check if aws_unset function is present in .zshrc
if ! grep -q "aws_unset ()" "$HOME/.zshrc"; then
    echo "aws_unset function not found in .zshrc, adding..."
    echo -e "\n$aws_unset_func" >> "$HOME/.zshrc"
else
    echo "aws_unset function already present in .zshrc."
fi

# Check if ag is installed
if ! command -v ag &> /dev/null; then
    echo "ag (The Silver Searcher) is not installed. Installing..."
    brew install the_silver_searcher
else
    echo "ag (The Silver Searcher) is already installed."
fi

# Define the directory path to check for the existence of the workspace folder
directory_path=~/workspace

# Check if the workspace folder exists
if [ ! -d "$directory_path" ]; then
  # If the workspace folder doesn't exist, create it
  mkdir -p "$directory_path"
  echo "Workspace folder created: $directory_path"
else
  echo "Workspace folder already exists: $directory_path"
fi


# # Plugin list
# plugins=(
#   git
#   kubectl
#   history
#   emoji
#   encode64
#   web-search
#   Copydir
#   Copyfile
#   Copybuffer
#   Dirhistory
#   history
# )

# # Convert plugin list to string
# plugin_string="plugins=("
# for plugin in "${plugins[@]}"; do
#   plugin_string+=" $plugin"
# done
# plugin_string+=" )"

# # Update .zshrc file with plugin list
# echo "$plugin_string" > ~/.zshrc

# # Reload zsh configuration
# source ~/.zshrc

# echo "Plugin list updated in .zshrc file!"

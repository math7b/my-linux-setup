#! /bin/bash

# exit on error
set -e

echo "The code will ask for sudo privilege to rum pacman."

ask() {
  while true; do
    read -rp "$1 (y/n): " yn
    [[ -z "$yn" ]] && return 0
    case "$yn" in
      [Yy]*) return 0 ;;
      [Nn]*) return 1 ;;
      *) echo "Please answer y or n." ;;
    esac
  done
}

if ask "Update the system package database?"; then
  sudo pacman -Syu --needed
fi

if ask "Stow some .config folders?"; then
  sudo pacman -S stow --needed
  if ask "Clone the math7b's dotfile?"; then
    if [ -d "$HOME/my-linux-setup/" ]; then
	    cd ~/my-linux-setup
      echo "Repository already exists. Pulling updates..."
      git pull
      cd ~/
    else
      echo "Repository not found. Cloning..."
      git clone https://github.com/math7b/my-linux-setup.git
    fi
    cd ~/my-linux-setup
    stow backgrounds archinstaller bashrc fastfetch hypr kitty rofi starship waybar wofi commands-list todo-list
    cd ~/
  fi
  if ask "Clone the typrcraft's dotfile?"; then
    if [ -d "$HOME/dotfiles/" ]; then
    cd ~/dotfiles
      echo "Repository already exists. Pulling updates..."
      git pull
    cd ~/
    else
      echo "Repository not found. Cloning..."
      git clone https://github.com/math7b/dotfiles.git
    fi
    cd ~/dotfiles
    stow nvim tmux
    cd ~/
  fi
fi

if ask "Install and configure Hyprland?"; then
  HYPR=(
    hyprland # 🪟 Hyprland & Wayland
    hyprshot
    waybar
    hyprlock
    hyprpaper
    hyprpicker
    wayland
    qt5-wayland
    qt6-wayland
    xdg-desktop-portal-hyprland
    spavucontrol # 🎵 Audio & Multimedia
    pamixer
    playerctl
    brightnessctl # ⚙️ System Utilities
    polkit
    polkit-kde-agent
  )
  for pkg in "${HYPR[@]}"; do
    echo "Installing: $pkg"
    sudo pacman -S --needed --noconfirm "$pkg" || true
  done
fi

if ask "Install the packages?"; then
  echo "Installing packages..."
  PACKAGES=(
    sbctl # 🛠️ Componentes Essenciais do Sistema
    nvtop
    dunst
    grim
    slurp
    uwsm
    bluez
    bluez-utils
    nerd-fonts # Fonts
    JetBrainsMono
    FiraCode
    ttf-noto-nerd
    noto-fonts-emoji
    ttf-nerd-fonts-symbols
    ttf-jetbrains-mono-nerd
    ttf-iosevka-nerd
    noto-fonts
    ttf-dejavu
    zenity
    vim # 🧠 Desenvolvimento e Ferramentas de Programação
    neovim
    git
    github-cli
    lazydocker
    libreoffice-still
    docker
    docker-compose
    code
    docker
    docker-compose
    kitty # 💻 Ambiente de Desktop / Sistema Gráfico
    rofi
    dolphin
    obs-studio
    nwg-look
    gnome-characters
    blueman
    discord # 🌐 Navegadores e Comunicação
    torbrowser-launcher
    btop # ⚙️ Ferramentas do Sistema (Qualidade de vida)
    fastfetch
    starship
    asciiquarium
    zoxide
    tree
    fzf
    tmux
    yazi
    unzip
    bat # 🗂️ Gerenciadores de Arquivos
    stow
    baobab
    7zip
    krita # 📝 Produtividade
    yt-dlp
    fuse2 # For AppImage
  )
  for pkg in "${PACKAGES[@]}"; do
    echo
    echo "Installing: $pkg"
    sudo pacman -S --needed --noconfirm "$pkg" || true
  done
fi

if ask "Configure Steam?"; then
  echo "Go to /etc/pacman.conf and remove the # in"
  echo "# [multilib]"
  echo "# Include = /etc/pacman.d/mirrorlist"
  if ! pacman -Qs steam > /dev/null; then
    if ask "Install Steam?"; then
      sudo pacman -Syu --needed
      sudo pacman -S steam
    fi
  fi
  if ask "Check steam for missing drivers?"; then
    STEAM_RUNTIME_VERBOSE=1 steam
    read -rp "Press ENTER to continue"
  fi
fi

if ask "Install drivers?"; then
  DRIVERS=(
    #intel-media-driver
    #libva-intel-driver
    #libva-mesa-driver
    #mesa
    #vulkan-intel
    #vulkan-nouveau
    #vulkan-radeon
    #xf86-video-amdgpu
    #xf86-video-ati
    #xf86-video-nouveau
    #xf86-video-vmware
    #xorg-server 
    #xorg-xinit
  )
  for pkg in "${DRIVERS[@]}"; do
    echo
    echo "Installing: $pkg"
    sudo pacman -S --needed "$pkg" || true
  done
fi

if ask "Check some systemctl services?"; then
  services=(
    bluetooth
    NetworkManager
  )
  for svc in "${services[@]}"; do
    if systemctl is-active --quiet "$svc"; then
      echo "$svc is running."
    else
      if ask "$svc is not running, do you want to enable it?"; then
        echo " Starting $svc"
        sudo systemctl enable --now "$svc"
      fi
    fi
  done
fi

if ask "Install flatpac stuffs?"; then
  flathub=(
    "flatpak install flathub com.github.tchx84.Flatseal"
    "flatpak install flathub app.zen_browser.zen"
    #I was having problens to mack zen install files in ~/Downloads
    #After this comand it worked even if reseting the configs in flatseal
    #flatpak override --user --filesystem=xdg-download app.zen_browser.zen
    "flatpak install flathub it.mijorus.smile"
    "flatpak install flathub com.heroicgameslauncher.hgl"
  )
  if ! flatpak --version >/dev/null 2>&1; then
    if ask "Install flatpak?"; then
      sudo pacman -S flatpak --needed
      echo "flatpak need a reboot"
      if ask "Reboot now?"; then
        reboot
      fi
    fi
  fi
  if ask "Install flathub programs?"; then
    for flat in "${flathub[@]}"; do
      if ask "Install - $flat?"; then
        $flat
      fi
    done
  fi
fi

filesToConfigure=(
  ~/Downloads/zoom_x86_64.pkg.tar.xz
  ~/Downloads/winboat-*-x86_64.AppImage
)
if ask "Proceed with graphical programs instalation?"; then
  if ask "Install web programs?"; then
    urls=(
        "https://zoom.us/download?os=linux"
        "https://nodejs.org/en/download"
        "https://www.winboat.app/"
    )
    for url in "${urls[@]}"; do
        if ask "Open $url?"; then
            xdg-open "$url" &
            read -rp "Press ENTER to continue"
        fi
    done
  fi
fi

if ask "Configure installed programs?"; then
  if [ -f ${filesToConfigure[0]} ]; then
    if ask "Configure Zoom now?"; then
      sudo pacman -U ${filesToConfigure[0]} --needed
    fi
  else
    echo "Install Zoom first to configure."
  fi
  if [ -f ${filesToConfigure[1]} ]; then
    if ask "Configure WinBoat now?"; then
        chmod +x ${filesToConfigure[1]}
        sudo pacman -S --needed freerdp
        sudo groupadd docker
        sudo usermod -aG docker $USER
        sudo systemctl enable --now docker
        #echo "Please log out and back in for Docker group changes to apply."
    fi
  fi
fi

start_winboat() {
  if [ -f ${filesToConfigure[1]} ]; then
    ${filesToConfigure[1]}
  else
    echo "WinBoat AppImage not found in ~/Downloads"
  fi
}
if [ -f ${filesToConfigure[1]} ]; then
  if ask "Start WinBoat now?"; then
    start_winboat
  fi
fi

echo
echo

echo "finished"

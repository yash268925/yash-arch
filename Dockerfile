FROM archlinux:base-devel

COPY mirrorlist /etc/pacman.d/mirrorlist

RUN pacman -Sy \
 && pacman -S --noconfirm \ 
      zsh git tig openssh man sudo neovim \
      nodejs npm lua deno go python python-pip \
 && npm install -g pnpm neovim \
 && pip install neovim-remote

RUN sed -i "/NOPASSWD/s/^# //g" /etc/sudoers

COPY zshrc/zshrc /etc/skel/.zshrc
COPY zshrc/zshrc.local /etc/skel/.zshrc.local
COPY neovim-init/* /etc/skel/.config/nvim/
COPY dircolors /etc/skel/.dircolors

RUN cd /etc/skel/.config/nvim \
 && mkdir autoload \
 && cd autoload \
 && curl -sLO https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

RUN useradd -m -G wheel -U -s /usr/sbin/zsh yash

USER yash
WORKDIR /home/yash

RUN git clone https://aur.archlinux.org/yay.git \
 && cd yay \
 && makepkg -si --noconfirm \
 && cd ../ \
 && rm -rf yay

RUN yay --noconfirm -S dtach

ENV SHELL=/usr/sbin/zsh
RUN TERM=xterm-256color zsh -i
RUN nvim --headless +PlugInstall +q +q

CMD ["zsh"]

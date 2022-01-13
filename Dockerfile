FROM archlinux:base-devel

COPY mirrorlist /etc/pacman.d/mirrorlist

RUN pacman -Sy \
 && pacman -S --noconfirm \ 
      zsh git tig openssh man sudo \
      nodejs npm lua deno go python python-pip \
 && npm install -g pnpm neovim \
 && pip install neovim-remote

RUN sed -i "/NOPASSWD/s/^# //g" /etc/sudoers

COPY zshrc/zshrc /etc/skel/.zshrc
COPY zshrc/zshrc.local /etc/skel/.zshrc.local
COPY neovim-init /etc/skel/.config/nvim/
COPY dircolors /etc/skel/.dircolors

RUN useradd -m -G wheel -U -s /usr/sbin/zsh user

RUN pacman -S --noconfirm skk-jisyo

USER user
WORKDIR /home/user

RUN git clone https://aur.archlinux.org/yay.git \
 && cd yay \
 && makepkg -si --noconfirm \
 && cd ../ \
 && rm -rf yay

RUN yay --noconfirm -S dtach neovim-nightly-bin

ENV SHELL=/usr/sbin/zsh
RUN TERM=xterm-256color zsh -i

RUN curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > /tmp/installer.sh \
 && sh /tmp/installer.sh ~/.cache/dein \
 && nvim --headless +"call dein#install()" +q +q \
 && nvim --headless +"TSUpdateSync" +q +q

CMD ["zsh"]

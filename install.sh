#
# Header explicativo documentado kkk
#

set -e
echo "Esse shell script não rodará pois você precisa preencher as informações"
FALHANDOagora

echo "Iniciando configuração de partições"
# Configuração das partições e swap (considerando que seu disco é o /dev/sda)
# mkfs.ext4 /dev/sda<Partição do arch linux> -L ARCH_ROOT
# mount /dev/sda<Partição do arch linux> /mnt
# mkdir /mnt/home

# Caso tenha uma partição para ponto de montagem '/home' (recomendado)
# mount /dev/sd<Partição /home> /mnt/home

# por questoes praticas foi decido que a configuração do grub estara em uma partiçao separada do /boot


# mkswap /dev/sda11 # swap?
# swapon /dev/sda11
mkfs.ext4 /dev/sda1 # -L ARCH_ROOT
mount /dev/sda1 /mnt
mkdir /mnt/home
mount /dev/sda10 /mnt/home

#   swap 1gb !melhor testar isto em produção!
# dd if=/dev/zero of=/mnt/swapfile bs=1024 count=1048576
# chmod 600 /mnt/swapfile
# mkswap /mnt/swapfile
# swapon /mnt/swapfile #poder nao sei se pode no livecd mas tem que botar depos no fstab
# testa isso
# depois da um: swapon --show
# tudo em sudo/root claro

pacstrap /mnt base base-devel

genfstab -Up /mnt >> /mnt/etc/fstab

printf "Configurando linguagem do sistema e layout do teclado"

echo "en_US.UTF-8 UTF-8" > /mnt/etc/locale.gen
arch-chroot /mnt /usr/bin/locale-gen

echo "LANG=en_US.UTF-8" > /mnt/etc/locale.conf

# ln -sf /mnt/usr/share/zoneinfo/Region/City /mnt/etc/localtime
# modifique ../America/Recife para a sua localidade mais proxima
ln -sf /mnt/usr/share/zoneinfo/America/Recife /mnt/etc/localtime
hwclock --systohc

echo "KEYMAP=br-abnt2" > /etc/vconsole.conf

printf "Ok!"

# Setting up PC name (hostname)
echo arch > /mnt/etc/hostname
echo "  Ok."
#

echo "Agora edite suas configurações do pacman (5 seg)"
echo "É recomendado que você descomente a seção [multilib], e colors"
sleep 5
vim /mnt/etc/pacman.conf

echo "Digite a senha do usuário 'root':"
arch-chroot /mnt passwd


arch-chroot /mnt pacman -Sy  \
zsh \
i3 \
i3status \
dmenu \
vim \
iwd \
termite \
grub-efi-x86_64 \
xorg-server \
xorg-xinit \
xf86-input-mouse \
xf86-input-keyboard  \
xf86-input-synaptics \
git
# pacman -S pulseaudio paprefs pavucontrol pulseaudio-alsa alsa-lib alsa-utils
# pacman -S alsa alsa-lib alsa-utils


echo "Adicione <seuUser> ALL=(ALL) ALL ao sudoers"
arch-chroot /mnt useradd -m -g users -G lp,wheel,adm,rfkill -s /bin/zsh marcospb19 # grupos opcionais
sleep 4
#-g = grupo principal, -G = grupos secundarios

arch-chroot /mnt vim /etc/sudoers

echo "Digite a senha do usuário marcospb19:"
arch-chroot /mnt passwd marcospb19

# ignorar no caso de ja ter grub instalado
# grub-install --target=x86_64-efi --efi-directory=/mnt --bootloader-id=grubAgoraVai --boot-directory=/mnt /dev/sda9
# olha aki pode instalar no live o pacote grub e instalar pelo liveCd o grub na partição
# so fiz atualizar pelo grub-mkconfig funfa de boa

# montando EFI particion

echo "instalando grub..."

# del? grub-mkconfig -o /mnt/mnt/grub/grub.cfg
mount /dev/sda9 /mnt/mnt
arch-chroot /mnt grub-mkconfig -o /mnt/grub/grub.cfg
# MUDANDO AQUI TERCEIRA PARTE

#aki deveria ta descomentado, ja que vvai gerar o arquvio que vai permitir o boot
#grub-mkconfig -o /mnt/mnt/grub/grub.cfg
# pelo que li os dois tao ok pq tem duas versoes? nao man percebi aki
# no livecd nao tem grub vai dar erro precisa ser via archchroot


# grub nao precisa instalar ja que voce ja tem, so se formatar tudo tipo geral todos os disco ate o esp
# mas precisa configurar :p

# grub nao precisa instalar ja que voce ja tem, so se formatar tudo tipo geral todos os disco ate o esp

umount -R /mnt
printf "Installation complete, reboot!"

# a parte das partições
# o grub tá com uns negócios estranhos
# --boatloader-id... abaixo
# --boot-directory pasta boot
# tá tudo certo já???????

# das? foi eu esse serve para nomear o boot no caso quando ele ta na boot options!
# pacman -S efibootmgr intel-ucode
# pacman -S plasma/xfce4/gnome/i3-gaps
# pacman -S wireless_tools networkmanager dialog wpa_actiond wpa_supplicant

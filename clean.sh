set -e
echo "Esse shell script não rodará pois você precisa preencher as informações"
#FALHANDOagora

echo "Iniciando configuração de partições"

mkfs.ext4 /dev/sda1 
mount /dev/sda1 /mnt
mkdir /mnt/home
mount /dev/sda10 /mnt/home

pacstrap /mnt base base-devel
genfstab -Up /mnt >> /mnt/etc/fstab

printf "Configurando linguagem do sistema e layout do teclado"
echo "en_US.UTF-8 UTF-8" > /mnt/etc/locale.gen
arch-chroot /mnt /usr/bin/locale-gen
echo "LANG=en_US.UTF-8" > /mnt/etc/locale.conf
ln -sf /mnt/usr/share/zoneinfo/America/Recife /mnt/etc/localtime
hwclock --systohc
echo "KEYMAP=br-abnt2" > /etc/vconsole.conf

printf "Ok!"

echo arch > /mnt/etc/hostname
echo "  Ok."

echo "Agora edite suas configurações do pacman (6 seg)"
echo "É recomendado que você descomente a seção [multilib], e colors"
sleep 3
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


echo "Adicione <seuUser> ALL=(ALL) ALL ao sudoers"
arch-chroot /mnt useradd -m -g users -G lp,wheel,adm,rfkill -s /bin/zsh marcospb19 
sleep 3
arch-chroot /mnt vim /etc/sudoers

echo "Digite a senha do usuário marcospb19:"
arch-chroot /mnt passwd marcospb19

echo "instalando grub..."
mount /dev/sda9 /mnt/mnt
arch-chroot /mnt grub-mkconfig -o /mnt/grub/grub.cfg
umount -R /mnt
printf "Installation complete, reboot!"



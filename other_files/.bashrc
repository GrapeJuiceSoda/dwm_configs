[ -f ~/.profile ] && . ~/.profile

set -o vi

#ignore upper and lowercase when TAB completion
bind "set completion-ignore-case on"

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ -d "$HOME/.bin" ] ;
  then PATH="$HOME/.bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ;
  then PATH="$HOME/.local/bin:$PATH"
fi

ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *.deb)       ar x $1      ;;
      *.tar.xz)    tar xf $1    ;;
      *.tar.zst)   unzstd $1    ;;      
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

backup ()
{
    # read -e -p "src: " src_dir
    # read -e -p "dest: " dest_dir
    youtube_src="/home/ken_nc/Videos/youtube/"
    youtube_dest="/volume2/backup/thinkpad_backup/kennc_Vid/youtube/"

    document_src="/home/ken_nc/Documents/"
    document_dest="/volume2/backup/thinkpad_backup/kennc_Doc/"

    download_src="/home/ken_nc/Downloads/"
    download_dest="/volume2/backup/thinkpad_backup/kennc_Down/"

    picture_src="/home/ken_nc/Pictures/"
    picture_dest="/volume2/backup/thinkpad_backup/kennc_Pic/"

    meme_src="/home/ken_nc/Videos/Memes/"
    meme_dest="/volume2/backup/thinkpad_backup/kennc_Vid/Memes/"

    recordings_src="/home/ken_nc/Videos/recordings/"
    recordings_dest="/volume2/backup/thinkpad_backup/kennc_Vid/recordings/"

    echo "Back Up Youtube"
    echo "------------------------"
    rsync -avuz $youtube_src ken_nc@192.168.1.49:$youtube_dest
    echo "Back Up Memes"
    echo "------------------------"
    rsync -avuz $meme_src ken_nc@192.168.1.49:$meme_dest
    echo "Back Up Documents"
    echo "------------------------"
    rsync -avuz $document_src ken_nc@192.168.1.49:$document_dest
    echo "Back Up Downloads"
    echo "------------------------"
    rsync -avuz $download_src ken_nc@192.168.1.49:$download_dest
    echo "Back Up Pictures"
    echo "------------------------"
    rsync -avuz $picture_src ken_nc@192.168.1.49:$picture_dest
    echo "Back Up Recordings"
    echo "------------------------"
    rsync -avuz $recordings_src ken_nc@192.168.1.49:$recordings_dest
}

tar_gz ()
{
    tar_file_name="$1.tar.gz"
    tar -czvf $tar_file_name $1
}

hdown ()
{
    nhentai --id=$1 --output=/home/ken_nc/.plzNo/.iSaidNo/.nooooo/manga/ --download
}

convert_img ()
{
    read -e -p "Output Format(jpg / png): " o_format
    read -e -p "Input Format(webp / jpg / png): " i_format
    read -e -p "Current Directory: " current
    if [[ "$current" != "y" ]]; then
        read -e -p "Directory: " $directory
        cd $directory
    fi
    # magick mogrify -format JPEG -path OUTPUT *.webp
    if [[ $(ls | grep -c "$i_format$") -ge 1 ]]; then
        printf "Stand by ...\n"
        magick mogrify -format $o_format *.$i_format
        rm *.$i_format
    else
        echo "No $i_format file found"
    fi
    if [[ -n "$directory" ]]; then
        cd -
    fi
}

convert_vid ()
{
    read -e -p "Output Format(mp4 / webm): " o_format
    read -e -p "Input Format(m4v / mp4 / webm): " i_format
    read -e -p "Current Directory: " current
    if [[ "$current" == "y" ]]; then
        directory=$(pwd)
    else
        read -e -p "Directory: " directory
        cd $directory
    fi
    if [[ $o_format == $i_format ]]; then
        echo "input and output format is the same"
        return 0
    fi
    for vid_file in "$directory"/*
    do
        if [[ "$vid_file" =~ "$i_format" ]]; then
            vid_name=$(echo "$vid_file" | sed -nr "s/(.*)(\.$i_format)/\1/p")
            ffmpeg -i "$vid_file" "$vid_name.$o_format"
            rm "$vid_file"
        else
            echo "File(s) not found"
        fi
    done
    if [[ "$directory" != "$(pwd)" ]]; then
        cd -
    fi
}

gcc_w (){
    output_file=$(echo $1 | sed -nr "s/(.*)(\.c)/\1/p")
    gcc -Wall -Wextra -Wformat-security -Wswitch-default $1 -o $output_file
}

#youtube-dl
alias yta-aac="youtube-dl --extract-audio --audio-format aac "
alias yta-best="youtube-dl --extract-audio --audio-format best "
alias yta-flac="youtube-dl --extract-audio --audio-format flac "
alias yta-m4a="youtube-dl --extract-audio --audio-format m4a "
alias yta-mp3="youtube-dl --extract-audio --audio-format mp3 "
alias yta-opus="youtube-dl --extract-audio --audio-format opus "
alias yta-vorbis="youtube-dl --extract-audio --audio-format vorbis "
alias yta-wav="youtube-dl --extract-audio --audio-format wav "
alias ytv-best="youtube-dl -f bestvideo+bestaudio "

#gpg
#verify signature for isos
alias gpg-check="gpg2 --keyserver-options auto-key-retrieve --verify"
#receive the key of a developer
alias gpg-retrieve="gpg2 --keyserver-options auto-key-retrieve --receive-keys"

alias vi=nvim

alias pacman='pacman --color auto'
#Cleanup orphaned packages
alias cleanup='sudo pacman -Rns $(pacman -Qtdq)'

alias dhelp='cat ~/Downloads/dwm/config.h'

#list
alias ls='exa'
alias la='exa -alh -G --header --git'
alias ll='ls -lh'
alias by_size='du -sm * | sort -nr | head -15'
# alias la='ls -a'
# alias ll='ls -l'

## Colorize the grep command output for ease of use (good for log files)##
alias ftc_code='cd Documents/programming/Ultimate-Goal/TeamCode/src/main/java/org/firstinspires/ftc/teamcode'
alias ftc='cd Documents/programming/Ultimate-Goal/'
alias website='cd Documents/programming/html/school_website'
alias colortest='./Downloads/color-scripts/color-scripts/colortest'

alias running_service='systemctl list-units --type=service'
alias time_table='feh ~/Pictures/screenshots/time_table.jpg'
alias diskstation='ssh ken_nc@192.168.1.49 -p22'
# alias rsync='rsync -avuz'
# rsync ~/Videos/Memes ken_nc@192.168.1.47:/volume2/backup/thinkpad_backup/Memes
# scp volume2/backup/thinkpad_backup/Memes ken_nc@192.168.1.45:~/Videos/Memes/
alias iftop='sudo iftop -i wlan0'
alias yay='paru'

alias grep='rg -i'
alias blog='blog.sh'
alias clock='plan9_clock'

alias clamscan='clamscan -vrz --bell --leave-temps --remove=yes'

alias fetch='fm6000 -de none -o Arch'
alias colortest='~/Downloads/color-scripts/color-scripts/colortest'
alias reset_clock='sudo timedatectl set-timezone UTC'

alias pl='. 91plumber'
alias tar_gz='tar czvf' #tar czvf mydirectory.tgz mydirectory

#cheatsheet
# xdg-settings set default-web-browser brave-browser.desktop
# xdg-settings set default-web-browser librewolf.desktop
# Start
clear
echo "ken_ncです。よろしくお願いします。"
echo "ken_ncです。よろしくお願いします。"
echo "ken_ncです。よろしくお願いします。"
echo "ken_ncです。よろしくお願いします。"
echo ''
cat ~/Documents/asciiArt/glenda

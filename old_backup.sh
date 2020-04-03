#!/bin/sh
# /home/byteframe/.liferea_1.6/cache/plugins/ivwoogv.opml
# /home/byteframe/.liferea_1.6/feedlist.opml
# /home/byteframe/.xchat2/servlist.conf
# /home/byteframe/.xchat2/xchat.conf
# /home/byteframe/.xchat2/scrollback
# /home/byteframe/.doom3/base/savegames/QuickSave.save
# /home/byteframe/.doom3/base/savegames/QuickSave.tga
# /home/byteframe/.doom3/base/savegames/QuickSave.txt
# /home/byteframe/.doom3/base/DoomConfig.cfg
# /home/byteframe/.doom3/base/doomkey
# /home/byteframe/.doom3/base/xpkey
# /home/byteframe/.duke3d/duke3d.cfg
# /home/byteframe/.duke3d/*.sav
# /home/byteframe/.etqwcl/base/etqwconfig.cfg
# /home/byteframe/.etqwcl/sdnet/byteframe/base/bindings.cfg
# /home/byteframe/.etqwcl/sdnet/byteframe/base/profile.cfg
# /home/byteframe/.hexen2/data1/config.cfg
# /home/byteframe/.hexen2/data1/quick
# /home/byteframe/.local/share/applications
# /home/byteframe/.local/share/icons
# /home/byteframe/.loki/rune/System/Rune.ini
# /home/byteframe/.loki/rune/System/User.ini
# /home/byteframe/.loki/sof/config.cfg
# /home/byteframe/.loki/sof/save/quick*.sof
# /home/byteframe/.prboom/prboom.cfg
# /home/byteframe/.prboom/prbmsav*.dsg
# /home/byteframe/.prey/base/preyconfig.cfg
# /home/byteframe/.prey/base/preykey
# /home/byteframe/.prey/base/savegames
# /home/byteframe/.q3a/baseq3/q3config.cfg
# /home/byteframe/.q3a/baseq3/q3key
# /home/byteframe/.quake2/baseq2/config.cfg
# /home/byteframe/.quake2/baseq2/save/quick
# /home/byteframe/.quake4/q4base/Quake4Config.cfg
# /home/byteframe/.quake4/q4base/quake4key
# /home/byteframe/.quake4/q4base/savegames/Quick1*
# /home/byteframe/.quake4/q4mp/Quake4Config.cfg
# /home/byteframe/.serious/serioussam/Players/Player0.plr
# /home/byteframe/.serious/serioussam/SaveGame/Player0/Quick
# /home/byteframe/.tyrquake/id1/config.cfg
# /home/byteframe/.tyrquake/id1/quick.sav
# /home/byteframe/.ut2004/System/UT2004.ini
# /home/byteframe/.ut2004/System/User.ini
# /home/byteframe/.wine/drive_c/Program Files/DeusEx/Save/QuickSave
# /home/byteframe/.wine/drive_c/Program Files/DeusEx/System/DeusEx.ini
# /home/byteframe/.wine/drive_c/Program Files/DeusEx/System/User.ini
# /home/byteframe/.wine/drive_c/Program Files/Diablo II/save
# /home/byteframe/.wine/drive_c/Program Files/Fallout 2/fallout2.cfg
# /home/byteframe/.wine/drive_c/Program Files/Fallout 2/DATA/SAVEGAME
# /home/byteframe/.wine/drive_c/Program Files/Grim Fandango/grim00.gsv
# /home/byteframe/.wine/drive_c/Program Files/StarCraft/characters/byteframe.spc
# /home/byteframe/.wine/drive_c/Program Files/StarCraft/save/byteframe
# /home/byteframe/.wine/drive_c/Program Files/Steam/steamapps/common/farcry/game.cfg
# /home/byteframe/.wine/drive_c/Program Files/Steam/steamapps/common/farcry/system.cfg
# /home/byteframe/.wine/drive_c/Program Files/Steam/steamapps/common/red orchestra/System/RedOrchestra.ini
# /home/byteframe/.wine/drive_c/Program Files/Steam/steamapps/common/red orchestra/System/User.ini
# /home/byteframe/.wine/drive_c/Program Files/Steam/steamapps/common/killingfloor/System/KillingFloor.ini
# /home/byteframe/.wine/drive_c/Program Files/Steam/steamapps/common/killingfloor/System/User.ini
# /home/byteframe/.wine/drive_c/Program Files/Steam/steamapps/ftgow@yahoo.com/insurgency/insurgency/cfg/config.cfg
# /home/byteframe/.wine/drive_c/Program Files/Steam/steamapps/ftgow@yahoo.com/zombie panic! source/zps/cfg/config.cfg
# /home/byteframe/.wine/drive_c/Program Files/Unreal Gold/Save/Save9.usa
# /home/byteframe/.wine/drive_c/Program Files/Unreal Gold/System/Unreal.ini
# /home/byteframe/.wine/drive_c/Program Files/Unreal Gold/System/User.ini
# /home/byteframe/.wine/drive_c/Program Files/Unreal Tournament/System/UnrealTournament.ini
# /home/byteframe/.wine/drive_c/Program Files/Unreal Tournament/System/User.ini
# /home/byteframe/.wine/drive_c/users/byteframe/My Documents/Deus Ex - Invisible War/SaveGames
# /home/byteframe/.wine/drive_c/users/byteframe/My Documents/Deus Ex - Invisible War/user.ini
# /home/byteframe/.wine/drive_c/users/byteframe/My Documents/Thief - Deadly Shadows/SaveGames
# /home/byteframe/.wine/drive_c/users/byteframe/My Documents/My Games/Oblivion/Saves
# /home/byteframe/.wine/drive_c/users/byteframe/My Documents/My Games/Unreal Tournament 3/UTGame
# /home/byteframe/.wolf/main/save/quicksave.svg
# /home/byteframe/.wolf/main/wolfconfig.cfg
# /home/byteframe/.wolf/main/wolfconfig_mp.cfg
# Back-up files to a writeable directory, reading from a list therein.

function log {
  echo -e $1 >> "pdl-backup.log";
  echo -e $1
}

if [ ! -z $1 ]; then
  SITE_DIR=$1
else
  SITE_DIR=$PWD
fi

if [ ! -w "$SITE_DIR" ]; then
  echo "error: $SITE_DIR does not exist or is not writeable"
elif [ ! -e "$SITE_DIR/pdl-backup.list" ]; then
  echo "error: $SITE_DIR/pdl-backup.list not found"
else
  mkdir -p "$SITE_DIR/$HOSTNAME"
  cd "$SITE_DIR/$HOSTNAME"
  log "running pdl-backup: `date`"
  cat "$SITE_DIR/pdl-backup.list" | while read LINE; do
    if [ ! "${LINE:0:1}" = "#" ]; then
      for FILE in "$LINE"; do
        if [ -r "$FILE" ]; then
          if [ -L "$FILE" ]; then
            FILE=`readlink -f "$FILE"`
          fi
          if [ -e "${FILE:1}" ]; then
            if ! diff "$FILE" "${FILE:1}" &> /dev/null; then
              fun=`stat -c %y "${FILE:1}"`
              fun="${fun:0:19}"
              fun="${fun/ /_}"
              mv "${FILE:1}" "${FILE:1}.$fun"
              log "archived: ${FILE}.$fun"
              cp -R -p --parents "$FILE" "$SITE_DIR/$HOSTNAME"
            fi
          else
            log "copying: $FILE"
            cp -R -p --parents "$FILE" "$SITE_DIR/$HOSTNAME"
          fi
        fi
      done
    fi
  done
  chown -R byteframe:users "$SITE_DIR/$HOSTNAME"
  log "stopped pdl-backup: `date`"
fi
#--parentsuse full source file name under DIRECTORY
#-p same as --preserve=mode,ownership,timestamps
# for v0.3 asterisks quoteing arg
# for v0.4 directorys will still wholy archive themelsves,

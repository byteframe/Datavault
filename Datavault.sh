#!/bin/sh

#----LOG------------------------------------------------------------------------
# JUL 08 2009 "initial backup"
# SEP 01 2009 "file list on usb"
# DEC 04 2009 "thinning, errata, lists"
# MAR 11 2010 "fsck, procedure"
# JUN 15 2010 "space remaining"
# SEP 07 2010 "permissions, volume label, main smart"
# DEC 01 2010 "rsync, fixes"
# MAR 12 2011 "normalize"
# JUN 30 2011 "faster normalize"
# SEP 20 2011 "normalize ignore, fixes"
# JAN 03 2012 "tee logging, fixes"
# MAY 10 2012 "fixes"
# SEP 22 2012 "comments, fixes"
# DEC 11 2012 "mkdir, new source, fixes"
# APR 17 2013 "destination changes, dry-run, fixes"
# OCT 12 2013 "pdl-steam, retouch non-video, fixes"
# JUN 29 2014 "archive game/computer + work/file/wii, idler fixes, image merge"
# JAN 19 2015 "fs/part, label, router, misc, drive swap, ide branch, fixes"
# JUL 26 2015 "neglect ide, game return"
# DEC 18 2015 "remove steam/sizes, idler simplify, new source+1tb, ntfs"
# APR 09 2016 "ntfs320, work subdir, galileo, fs perms, size only, xfce4pm"
# JUN 26 2016 "320fix, cfdisk, sort find, ssh/pdl, inactive set, host rearrange"
# NOV 01 2016 "last image/torrent, mark inactive drive, obsolete ide, arg check"
# APR 05 2017 "archive I/D/G, remove host drives, movie/goutputstreams check, X"
# OCT 14 2017 "m3u, remove inactive dest, easier additions with new folders"
# MAY 22 2018 "no more smart, just one dest, ignore _new, m3u random, gid/uid"
# APR 19 2019 "scandisk check, include new videos"
# SEP 22 2019 "lost+found permissions, !randum, fix perm check, !___new"
# AUG 26 2020 "image/software, no aaa_misc"
# NOV 10 2020 "fix-swap source/destination 4tb, name checks find image, change ext4 for ntfs"
#----SOURCE---------------------------------------------------------------------
# [_11g] Image
# [265g] Software
# [2.4g] Work
# [_72g] Audio
# [647g] Video/Documentary
# [574g] Video/Movie
# [1.7t] Video/Television
# [481g] ST4000LM0161L5C {NTFS} Datavault
#----DESTINATION----------------------------------------------------------------
# [239g] ST4000LM016GM2X {NTFS} Datavault
#----SORTING--------------------------------------------------------------------
# make directory for explicit sets and groupings of related SRC, if preferred
# segments: append number at the end, using digits and "Part x" when called for
# use " - " for SRC that belong (or could belong) to a set or artist
#   if needed, include order number as second " - " delimited element,
#   unless it's an album file, then use as first element
# album: "00 - Artist - [Album] - Name"
# episode: "Show - 0S0E[ - Part1[ - Part2]].*", doubles being numbered as one
# put ', (A|An|The)' at end of a unnumbered documentary, movie, artist, episode
# easytag: disable(preserve modtime, convert underscore)
#-------------------------------------------------------------------------------

FILES="Audio Image Video Software Work"

function generate_list()
{
  find ${FILES} -type f -exec du -b {} \; | sort -k 2
}

function sync_destination()
{
  if [ -z $1 ]; then
    echo "error: no destination specified";
    exit 1
  fi
  DST=${1}
  mkdir -p "${DST}"/Video
  for DIR in $(ls --hide=lost+found --hide=Video "${DST}"); do
    if [ -d "${DIR}" ]; then
      echo "${DST}"/"${DIR}:"
      rsync --delete --size-only -l${PERMS}truv${N} \
        "${DIR}"/ "${DST}"/"${DIR}" ; echo
    fi
  done
  for DIR in $(ls "${DST}"/Video); do
    if [ -d Video/"${DIR}" ]; then
      echo "${DST}"/Video/"${DIR}:"
      rsync --delete --size-only -${PERMS}truv${N} \
        Video/"${DIR}"/ "${DST}"/Video/"${DIR}" ; echo
    fi
  done
  if [ -z ${N} ]; then
    echo -e "\ngenerating list..."
    rm -f "${DST}"/datavault-*
    generate_list > "${DST}"/datavault-$(date +%Y.%m.%d)
  fi
  echo "[destination remaining]" ; df -h /dev/${DDEV}
}

DATE=$(date +%s)
cd /mnt/Datavault

# adjust fs check call for ntfs filesystems
function determine_ntfs()
{
  if blkid /dev/${1} | grep -q ntfs; then
    FSCK="ntfsfix"
    unset PERMS
  else
    FSCK="e2fsck -f"
    PERMS=gop
  fi
}
SDEV=sdd1
determine_ntfs ${SDEV}

# generate video playlist
if [ -z ${1} ]; then
  if [ ! -z ${RANDUM} ]; then
    {
      echo "#EXTM3U"
      find Video/ -type f -not -path "*___NEW*" -not -name "*.m3u" | sed -e "s/Video\///" | sort --random-sort
    } > Video/Randum.m3u
  fi

  # check file permissions
  {
    if [ "${FSCK}" != ntfsfix ]; then
      find ${FILES} -not -uid 1000 -o -not -gid 100 -exec chown -v 1000:100 {} \;
      find ${FILES} -not -perm 0755 -type d -exec chmod -c 755 {} \;
      find ${FILES} -not -perm 0644 -type f -exec chmod -c 644 {} \;
    fi

    # check for filename mistakes
    find Audio -mindepth 3 -type d -not -path "*Speech*" -not -path "*__NEW*"
    find Audio -type f -not -path "*__NEW*" -not -iname *.mp3 -not -iname *.m3u
    find Work -type f -name ".goutputstream*"
    find Video/Movie -type f -exec basename {} \; \
      | sed 's/\(.*\)\..*/\1/' | sort | tr '[:lower:]' '[:upper:]' \
      | uniq -c | grep -v "^[ \t]*1 "
    FOUND=$(find ${FILES} -not -path "Work/*" -not -path "*___NEW/*" \( -name ".*" \
      -o -iregex ".*\s\(isnt\|lets\|dont\|wont\)\s.*" -o -regex ".*\s\s.*" \
      -o -regex ".*\s\(are\|be\|by\|my\|isn't\|it\|than\|then\|there\|that\|this\|was\|without\)\s.*" \
      -o -regex ".*[^,-]\s\(A\|An\|And\|As\|At\|For\|From\|If\|Is\|In\|Into\|Of\|On\|Or\|The\|To\|With\)\s[^(].*" \
      -o -regex ".*[~:;&?*<>].*" -o -iregex ".*\s\(v\.?\|vs\|versus\.?\)\s.*" \) | sort)
    IFS=$'\n'
    for FILE in ${FOUND}; do
      FILE=${FILE/\[/\\\[}
      if ! grep -q -e "${FILE}" Work/Datavault/normalize_ignore; then
        echo "${FILE/\\/}"
      fi
    done
    unset IFS
  } 2>&1 | tee ${HOME}/Datavault-${DATE}.log
  echo PAUSE
  read PAUSE
fi

# pause power manager
kill -STOP $(pgrep -fx xfce4-power-manager)

# check source hard drive
if [ $(hostname) = Datavault ]; then
  if [ ! -z ${SCANDISK} ]; then
    cd && umount /mnt/Datavault ; ${FSCK} /dev/${SDEV} \
      && mount /mnt/Datavault && cd /mnt/Datavault
    if [ ! -z ${SMART} ]; then
      smartctl -t short -d sat /dev/${SDEV:0:3} && echo -e "\n[sleep 150]" && sleep 150
      smartctl -a /dev/${SDEV:0:3} -d sat > Work/Datavault/SMART/SMART-$(date +%Y.%m.%d)
    fi
  fi
  echo "[source remaining]" ; df -h /mnt/Datavault
  echo "[source content]" ; du --apparent-size -s -h Image Software Work Audio \
    Video/Documentary Video/Movie Video/Television
  echo -e "\ngenerating list..." ; \
    generate_list > Work/Datavault/List/datavault-$(date +%Y.%m.%d)
  chown -R byteframe:users Work/Datavault

  # backup to attached hard drive
  echo "[for each destination]"
    DMNT=/mnt/tmp
    DDEV=sdd1
    determine_ntfs ${DDEV} ; echo ${FSCK}
    umount /dev/${DDEV} ; ${FSCK} /dev/${DDEV} && mount /dev/${DDEV} ${DMNT}
    sync_destination ${DMNT}
    umount /dev/${DDEV}

# backup to local directory
elif [ -d /home/byteframe/Datavault ]; then
  DDEV=sdZ2
  sync_destination /home/byteframe/Datavault 2>&1 | tee -a ${HOME}/Datavault-${DATE}.log
fi

# resume power manager
kill -CONT $(pgrep -fx xfce4-power-manager)

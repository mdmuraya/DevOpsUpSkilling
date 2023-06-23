#!/bin/bash

validMonths=(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec)

Owner(){
    echo "Looking for files where the owner is: $owner"
    for file in ./*
    do
        local fileOwner=$(stat -c %U $file)
        
        if [ $fileOwner = $owner ]; then
          lines=$(wc -l $file)
          echo "File: $file, Lines:              $lines"
        fi
    done
}

Month(){
    local isValidMonth=0
    for i in "${validMonths[@]}"
    do
        if [ "$i" == "$month" ] ; then
            isValidMonth=1
            break
        fi
    done

    if ((isValidMonth > 0)) ; then
      echo "Looking for files where the month is: $month"
      for file in ./*
      do
          local birthTime=$(stat -c %w $file)
          local birthMonth=$(date -d "$birthTime" +'%b')
          
          if [ $birthMonth = $month ]; then
            lines=$(wc -l $file)
            echo "File: $file, Lines:              $lines"
          fi
      done
    else
      ShowHelp
      exit 1
    fi
    
    
}



ShowHelp(){
    echo "Script usage: $(basename "$0") [-o owner] [-m month]"
    echo "The month should be one of the following: Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct,Nov or Dec"
}

while getopts 'o:m:' OPTION; do
  case "$OPTION" in
    o)
      owner="$OPTARG"
      ;;
    m)
      month="$OPTARG"
      ;;
    *)
      ShowHelp
      exit 1
      ;;
  esac
done

if [ $OPTIND -eq 1 ] || [ $OPTIND -gt 3 ]; then
   ShowHelp
   exit 1
fi

if [ -n "$owner" ]; then
    Owner
elif [ -n "$month" ]; then
    Month
fi

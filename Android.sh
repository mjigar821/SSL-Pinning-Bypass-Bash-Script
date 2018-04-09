#!/bin/bash
zipalign () {
	echo "zipalign if required."
}
jarsigner () {
	sign=$(which jarsigner)
	newapk="$directory/dist/$apkname"
	sign="$sign -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore '$presentDirectory' -storepass abc@123 '$newapk' Ali3nWar3"
	eval "$sign"
	zipalign
}
keytool () {
	presentDirectory=$(pwd)
	presentDirectory="$presentDirectory/Ali3nWar3.keystore"
	if [ -f "$presentDirectory" ]
		then
			jarsigner
		else
			echo "keystore is not present"
	fi
}
rebuild () {
	build=$(which apktool)
	build="$build b $directory"
	eval "$build"
	keytool
}
manifest () {
	manifest_path="$directory/AndroidManifest.xml"
	replacement='<application android:networkSecurityConfig="@xml/network_security_config"'
	sed -i "s#<application#$replacement#g" "$manifest_path"
	rebuild
}
networkconfig () {
	network_file_path="$directory/res/xml/"
	if [ ! -d "$network_file_path" ] 
		then
 			mkdir "$network_file_path"
	fi
	network_file_path="$network_file_path/network_security_config.xml"
	touch $network_file_path
	echo "<?xml version='1.0'?>
<network-security-config>
  <base-config>
    <trust-anchors>
      <!-- Trust preinstalled CAs -->
      <certificates src='system'/>
      <!-- Additionally trust user added CAs -->
      <certificates src='user'/>
    </trust-anchors>
  </base-config>
</network-security-config>" > $network_file_path
	manifest
}
apktool () {
	if command -v apktool &>/dev/null
		then
			directory=${file_path::-4}
			echo file_path
			apk=$(which apktool)
			apk="$apk d $file_path"
			eval "$apk"
			
			networkconfig
		else
			echo "apktool is not installed. Please install and try again."
	fi
}
if [ $# -eq 0 ]
	then
		echo "APK file location required"
	else
		file_path=$1
		if [ -f "$file_path" ]
			then
				apkname=$(basename "$file_path")
				if [ ${file_path: -4} == ".apk" ]
					then
						apktool
					else
						echo "apk not present"
				fi
			else
				echo "File not present"
		fi
fi

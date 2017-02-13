#!/bin/bash
echo $OS_Android_version
echo $build_type
echo $soc_vendor

mmx_key_path="/ODMSIGN/yuos/Android6.0/build/target/product/security"

odm_name="MMX"

path_of_target_file="/ODMSIGN/ODM/$odm_name"

target_file_name="sourcefile.zip"

date_time_stamp=$(date +%Y%m%d%H%M%S)

echo "changing location to build.prop file"
cd /ODMSIGN/ODM/$odm_name/
Build_ID=$(cat build.prop | grep ro.build.id= | cut -c13- |tr -d '\r')
#build_fp=cat build.prop | grep ro.build.fingerprint= | cut -c22-
mmx_build_version=$(cat build.prop | grep ro.build.version.release= | cut -c26-)
#$manufacturer=cat build.prop | grep ro.product.manufacturer= | cut -c24- |tr -d '\r'
#if [ "$manufacturer" = "YU" ]
#then
#target_product=cat build.prop | grep ro.yu.device= | cut -c13-
#else
target_product=$(cat build.prop | grep ro.product.device= | cut -c19-)
#fi
path_of_old_signed_target_files="/ODMSIGN/ODM/$odm_name/$target_product/Signed-MMX-*.zip"

if [ "$build_type" == "Incremental OTA" ]; then
	if [ ! -f $path_of_old_signed_target_files ]; then
    	echo File not found!
		exit 1
	fi
else
	if [ ! -f $path_of_old_signed_target_files ]; then
		mkdir $target_product
	fi
fi

new_path_of_signed_target_files="/ODMSIGN/ODM/$odm_name/$target_product/"



echo "Exporting variables...."
export OS_Android_version
export build_type
export soc_vendor
export mmx_key_path
export path_of_target_file
export new_path_of_signed_target_files
export target_file_name
export target_product
export mmx_build_version
export Build_ID
export date_time_stamp
export odm_name

echo "Changing location"
cd /ODMSIGN/yuos/Android6.0

echo "Starting Sign..."
source Sign.sh
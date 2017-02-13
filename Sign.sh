#Variables This need to be defined in each signing proces.

#$(target_file_name) example p7201-target_files-1474857792.zip
#$(mmx_key_path)  example /home/gursimran/YUClosed/vendor/yuos/security/yuos_keys
#$(path_of_target_file) example  /home/gursimran/ODM/tinno/dist
#$(new_path_of_signed_target_files) example /home/gursimran/YUClosed
#$(OS_Android_version) example MM-6.0.1
#$(Build_ID) Example MMB30K
#$(mmx_build_version) Example MMXMR1.0
#$(target_product) Example jalebi

#echo "hi"
#echo $target
#echo $2
# Signing ODM GIVEN TARGET FILES
#echo $target_file_name
#echo $mmx_key_path
#echo $path_of_target_file
#echo $new_path_of_signed_target_files
#echo $OS_Android_version
#echo $Build_ID
#echo $mmx_build_version
#echo $target_product

#build_type=$1
#target_file_name=$2
#mmx_key_path=$3
#path_of_target_file=$4
#new_path_of_signed_target_files=$5
#OS_Android_version=$6
#Build_ID=$7
#mmx_build_version=$8
#target_product=$9
#soc_vendor=${10}
#date_time_stamp=${11}
#echo $target
#echo $2
echo " Signing ODM GIVEN TARGET FILES"
echo $build_type
#echo "1111"
echo $target_file_name
echo $mmx_key_path
echo $path_of_target_file
echo $new_path_of_signed_target_files
echo $OS_Android_version
echo $Build_ID
echo $mmx_build_version
echo $target_product
echo $soc_vendor
echo $date_time_stamp
echo $odm_name
#echo "Signing starts"

if [ "$soc_vendor" == "Spreadtrum" ];
then
echo "Signing for Spreadtrum"
./build_spreadtrum/tools/releasetools/sign_target_files_apks.py -o -d $mmx_key_path/  $path_of_target_file/$target_file_name $new_path_of_signed_target_files/Signed-MMX-$date_time_stamp-$OS_Android_version-$Build_ID-$mmx_build_version_$target_product.zip
	if [ "$build_type" == "Factory" ];
	then
	echo "Factory spreadtrum"
	./build_spreadtrum/tools/releasetools/img_from_target_files $new_path_of_signed_target_files/Signed-MMX-$date_time_stamp-$OS_Android_version-$Build_ID-$mmx_build-$mmx_build_version_$target_product.zip $new_path_of_signed_target_files/MMX-$OS_Android_version-$Build_ID-$mmx_build_version_$target_product-Signed-fastboot-images-$date_time_stamp.zip
	aws s3 cp $new_path_of_signed_target_files/MMX-$OS_Android_version-$Build_ID-$mmx_build_version_$target_product-Signed-fastboot-images-$date_time_stamp.zip s3://yuopenos/$odm_name/
	props=$(ls $new_path_of_signed_target_files -t1 | head -n 1 | tr -d '\r')
	cd $WORKSPACE
	echo props=$props > build.properties


	else
	#Signed OTA PACKAGES
	echo "ota spreadtrum"
	./build_spreadtrum/tools/releasetools/ota_from_target_files --block \
  	 -k $mmx_key_path/releasekey \
 	$new_path_of_signed_target_files/Signed-MMX-$date_time_stamp-$OS_Android_version-$Build_ID-$mmx_build_version_$target_product.zip \
   	$new_path_of_signed_target_files/Signed-MMX-$date_time_stamp-$OS_Android_version-$Build_ID-$mmx_build_version_$target_product-ota.zip
aws s3 cp $new_path_of_signed_target_files/Signed-MMX-$date_time_stamp-$OS_Android_version-$Build_ID-$mmx_build_version_$target_product-ota.zip s3://yuopenos/$odm_name/
	props=$(ls $new_path_of_signed_target_files -t1 | head -n 1 | tr -d '\r')
	cd $WORKSPACE
	echo props=$props > build.properties
	fi

else
	echo "Signing other image"
	#./build/tools/releasetools/sign_target_files_apks.py -o -d  /home/gursimran/YUClosed/vendor/yuos/security/yuos_keys/ /home/gursimran/ODM/tinno/dist/*-target_files-*.zip signed-target_files_tinno.zip
	./build/tools/releasetools/sign_target_files_apks.py -o -d $mmx_key_path/  $path_of_target_file/$target_file_name $new_path_of_signed_target_files/Signed-MMX-$date_time_stamp-$OS_Android_version-$Build_ID-$mmx_build_version_$target_product.zip

	#Fastboot Images
	if [ "$build_type" == "Factory" ];
	then
	echo "Factory-signing"
	./build/tools/releasetools/img_from_target_files.py $new_path_of_signed_target_files/Signed-MMX-$date_time_stamp-$OS_Android_version-$Build_ID-$mmx_build_version_$target_product.zip $new_path_of_signed_target_files/MMX-$OS_Android_version-$Build_ID-$mmx_build_version_$target_product-Signed-fastboot-images-$date_time_stamp.zip
	aws s3 cp $new_path_of_signed_target_files/MMX-$OS_Android_version-$Build_ID-$mmx_build_version_$target_product-Signed-fastboot-images-$date_time_stamp.zip s3://yuopenos/$odm_name/
	props=$(ls $new_path_of_signed_target_files -t1 | head -n 1 | tr -d '\r')
	cd $WORKSPACE
	echo props=$props > build.properties
	elif [ "$build_type" == "Full OTA" ];
	then
	#Signed OTA PACKAGES
	echo "ota-signing"
	./build/tools/releasetools/ota_from_target_files.py --block \
  	 -k $mmx_key_path/releasekey \
 	$new_path_of_signed_target_files/Signed-MMX-$date_time_stamp-$OS_Android_version-$Build_ID-$mmx_build_version_$target_product.zip \
   	$new_path_of_signed_target_files/Signed-MMX-$date_time_stamp-$OS_Android_version-$Build_ID-$mmx_build_version_$target_product-full-ota.zip
	aws s3 cp $new_path_of_signed_target_files/Signed-MMX-$date_time_stamp-$OS_Android_version-$Build_ID-$mmx_build_version_$target_product-full-ota.zip s3://yuopenos/$odm_name/
	props=$(ls $new_path_of_signed_target_files -t1 | head -n 1 | tr -d '\r')
	cd $WORKSPACE
	echo props=$props > build.properties
	else
	last_target_file=$(ls $new_path_of_signed_target_files/Signed-MMX-* -Art | tail -n 2 | head -n 1 | tr -d '\r')
	./build/tools/releasetools/img_from_target_files.py $new_path_of_signed_target_files/Signed-MMX-$date_time_stamp-$OS_Android_version-$Build_ID-$mmx_build_version_$target_product.zip $new_path_of_signed_target_files/MMX-$date_time_stamp-$OS_Android_version-$Build_ID-$mmx_build_version_$target_product.zip
	./build/tools/releasetools/ota_from_target_files.py --block \
	 -k $mmx_key_path/releasekey \
	 -i $last_target_file \
	 $new_path_of_signed_target_files/Signed-MMX-$date_time_stamp-$OS_Android_version-$Build_ID-$mmx_build_version_$target_product.zip $new_path_of_signed_target_files/MMX-$date_time_stamp-$OS_Android_version-$Build_ID-$mmx_build_version_$target_product-incremental-ota.zip
	aws s3 cp $new_path_of_signed_target_files/MMX-$date_time_stamp-$OS_Android_version-$Build_ID-$mmx_build_version_$target_product-incremental-ota.zip s3://yuopenos/$odm_name/
	props=$(ls $new_path_of_signed_target_files/MMX-*-incremental-* -t1 | head -n 1 | xargs -n 1 basename | tr -d '\r')
	cd $WORKSPACE
	echo props=$props > build.properties
	fi
fi

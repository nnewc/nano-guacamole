#!/bin/bash

. ./env.sh

function upload_product {
	hauler store copy registry://${offline_registry}
}

#for i in `ls ../0_connected_download_carbide/artifacts/`;do
#	pushd ../0_connected_download_carbide/artifacts/${i}
#	upload_product ${i}
##	popd
#done

for i in `ls ../1_connected_download_appco/artifacts/`;do
	pushd ../1_connected_download_appco/artifacts/${i}
	upload_product ${i}
	popd
done

for i in `ls ../2_connected_download_thirdparty/artifacts/`;do
	pushd ../2_connected_download_thirdparty/artifacts/${i}
	upload_product ${i}
	popd
done

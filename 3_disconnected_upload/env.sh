#!/bin/bash

offline_registry=harbor.homelab.lan
platform=linux/amd64

#sync the helm charts
function sync_charts {
	mkdir -p artifacts/${1}
	pushd artifacts/${1}
	hauler store add chart ${2} --version ${3} --repo ${4} 
	popd
}

function sync_product {
	mkdir -p artifacts/${1}
	pushd artifacts/${1}
	hauler store sync --platform ${platform} --products ${1}=${2} --product-registry registry.ranchercarbide.dev
	popd

}

function upload_product {
	hauler store copy registry://${offline_registry}
}

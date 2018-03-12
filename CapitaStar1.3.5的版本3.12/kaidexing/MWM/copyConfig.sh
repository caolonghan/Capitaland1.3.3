#!/bin/sh

#  copyConfig.sh
#  kaidexing
#
#  Created by dwolf on 2017/6/14.
#  Copyright © 2017年 dwolf. All rights reserved.
echo "CONFIGURATION -> ${CONFIGURATION}"
RESOURCE_PATH=${SRCROOT}/${PRODUCT_NAME}/envconfig/${CONFIGURATION}

BUILD_APP_DIR=${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app

echo "Copying all files under ${RESOURCE_PATH} to ${BUILD_APP_DIR}"
cp -v "${RESOURCE_PATH}/"* "${BUILD_APP_DIR}/"

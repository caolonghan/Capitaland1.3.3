/**
* Copyright (c) 2015-2016 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
* EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
* and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
*/

#ifndef __EASYAR_CLOUD_HPP__
#define __EASYAR_CLOUD_HPP__

#include "easyar/base.hpp"

namespace easyar {

class TargetList;
class CloudRecognizerCallBack;
class CloudRecognizerInitCallBack;
class CameraDevice;

class CloudRecognizer : public RefBase
{
public:
    enum InitStatus
    {
        kCloudInitSuccess,
        kCloudInitFail,
    };

    enum Status
    {
        kCloudRecognizeSuccess,
        kCloudRecognizeReconnecting,
        kCloudRecognizeFail,
    };

    CloudRecognizer();
    virtual ~CloudRecognizer();

    virtual bool attachCamera(const CameraDevice& obj);
    virtual bool detachCamera(const CameraDevice& obj);
    void connect(const char* server, const char* appKey, const char* appSecret, CloudRecognizerInitCallBack* callback);
    bool close();

    bool start(CloudRecognizerCallBack* callback);
    bool stop();
};

class CloudRecognizerInitCallBack
{
public:
    virtual void operator() (CloudRecognizer::InitStatus status) = 0;
};

class CloudRecognizerCallBack
{
public:
    virtual void operator() (CloudRecognizer::Status status, TargetList targets) = 0;
};

}

#endif

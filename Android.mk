#
# Copyright (C) 2022 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_PREBUILT_KERNEL),)
QCA9377_PATH    := $(abspath $(call my-dir))
QCA_DRIVER_PATH := AIO/drivers/qcacld-new

include $(CLEAR_VARS)

LOCAL_MODULE        := qca9377
LOCAL_MODULE_SUFFIX := .ko
LOCAL_MODULE_CLASS  := ETC
LOCAL_MODULE_PATH   := $(TARGET_OUT_VENDOR)/lib/modules

_qca9377_intermediates := $(call intermediates-dir-for,$(LOCAL_MODULE_CLASS),$(LOCAL_MODULE))
_qca9377_ko := $(_qca9377_intermediates)/$(LOCAL_MODULE)$(LOCAL_MODULE_SUFFIX)
KERNEL_OUT := $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ
QCA9377_CONFIGS :=WLAN_ROOT=$(abspath $(_qca9377_intermediates))/$(QCA_DRIVER_PATH) MODNAME=wlan CONFIG_QCA_WIFI_ISOC=0 CONFIG_QCA_WIFI_2_0=1 CONFIG_QCA_CLD_WLAN=m WLAN_OPEN_SOURCE=1 CONFIG_CLD_HL_SDIO_CORE=y CONFIG_LINUX_QCMBR=y CONFIG_NON_QC_PLATFORM=y

$(_qca9377_ko): $(KERNEL_OUT)/arch/$(KERNEL_ARCH)/boot/$(BOARD_KERNEL_IMAGE_NAME)
	@mkdir -p $(dir $@)
	@cp -R $(QCA9377_PATH)/* $(_qca9377_intermediates)/
	$(hide) +$(KERNEL_MAKE_CMD) $(PATH_OVERRIDE) $(KERNEL_MAKE_FLAGS) -C $(KERNEL_OUT) M=$(abspath $(_qca9377_intermediates))/$(QCA_DRIVER_PATH) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) $(KERNEL_CROSS_COMPILE)  modules $(QCA9377_CONFIGS)
	$(KERNEL_TOOLCHAIN_PATH)strip --strip-unneeded $(dir $@)/$(QCA_DRIVER_PATH)/wlan.ko; \
	cp $(dir $@)/$(QCA_DRIVER_PATH)/wlan.ko $@;

include $(BUILD_SYSTEM)/base_rules.mk

endif
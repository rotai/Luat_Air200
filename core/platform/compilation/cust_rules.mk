#********************************************************#
# Copyright (C), AirM2M Tech. Co., Ltd.
# Author: lifei
# Description: AMOPENAT 开放平台
# Others:
# History: 
#   Version： Date:       Author:   Modification:
#   V0.1      2012.12.14  lifei     创建文件
#********************************************************#
include ${SOFT_WORKDIR}/project/${PROJ_NAME}/target/target.def
include ${SOFT_WORKDIR}/platform/chip/defs/${CT_ASIC}_base.def
ifeq "$(strip $(AM_MODEL))" ""
    $(error "!!!! AM_MODEL=${AM_MODEL} - Not a valid value, pls check file:${SOFT_WORKDIR}/project/${PROJ_NAME}/target/target.def !!!!")
endif
include ${SOFT_WORKDIR}/platform/${strip ${AM_MODEL}}/memd/memd.def

########################################################################
# MAKELEVEL=0 Things to do only once
# Variables that are defined only once should be in this section and 
# exported to sub-make
########################################################################
ifeq ($(MAKELEVEL),0)

# Check if CT_RELEASE is defined and valid
ifeq "$(strip $(CT_RELEASE))" ""
    export CT_RELEASE := debug
endif
VALID_RELEASE_LIST :=release debug
SELECTED_RELEASE := $(filter $(VALID_RELEASE_LIST), $(CT_RELEASE))
ifeq "$(SELECTED_RELEASE)" ""
    $(error "!!!! CT_RELEASE=${CT_RELEASE} - Not a valid release type !!!!")
endif

##########################################
# Define the tools to use
##########################################
export CROSS ?= mips-elf-

export AS := $(CROSS)as
export CC := $(CROSS)gcc
export CPP := ${CC} -E
export C++ := $(CROSS)g++ 
export AR := $(CROSS)ar
export OBJCOPY := $(CROSS)objcopy
export OBJDUMP := $(CROSS)objdump
export NM := $(CROSS)nm
export LD := $(CROSS)ld
# To preprocess non-C-code files (no line numbers, no garbage, no predefined vars)
export LDPP := $(CROSS)cpp -C -P -undef 
export GDB ?= $(CROSS)gdbtui

export CP := cp -f
export FIND := find
export DIFF := diff

export STDOUT_NULL := 1>/dev/null
export ECHO := echo

export MAKEFLAGS += -s --no-print-directory

export LIBGCC_PATH := ${SOFT_WORKDIR}/platform/lib/gcc/mips-elf/4.4.2
export CYGPATH := cygpath -am
##############################################################################
# Generic environment stuff
###############################################################################
## Generic directory names
ifneq "$(EX_VER)" ""
  export BUILD_DIR := build/${EX_VER}
else
  export BUILD_DIR := build/${PROJ_NAME}
endif

export OBJ_DIR := obj
export SRC_DIR := src
export LIB_DIR := lib
export DEPS_DIR := deps
export INC_DIR := include

# BUILD_ROOT is the base of the build tree,
# just like SOFT_WORKDIR is that of the source tree
# It defaults to  ${SOFT_WORKDIR}/${BUILD_DIR} when OBJECT_DIR is not set.
ifneq "$(OBJECT_DIR)" ""
export BUILD_ROOT := ${OBJECT_DIR}/${BUILD_DIR}
else
export BUILD_ROOT := ${SOFT_WORKDIR}/${BUILD_DIR}
endif

export HEX_PATH ?= ${SOFT_WORKDIR}/hex

# platform elf & lod file
AM_MODEL := ${strip ${AM_MODEL}}
ifneq "${AM_MODEL}" ""
    AM_PLT_ELF_PATH := ${SOFT_WORKDIR}/platform/${strip ${AM_MODEL}}
    AM_PLT_ELF_FILE := ${wildcard ${AM_PLT_ELF_PATH}/*.elf}
    AM_PLT_ELF_FILE_BASENAME := ${notdir ${AM_PLT_ELF_FILE}}
    ifeq "${words ${AM_PLT_ELF_FILE}}" "0"
        ${warning WARNING: No platform elf file at path: ${AM_PLT_ELF_PATH}}
    else
        ifneq "${words ${AM_PLT_ELF_FILE}}" "1"
            ${error ERROR: More than one platform elf file at path: ${AM_PLT_ELF_PATH}}
        endif
        export AM_PLT_ELF_FILE
        export AM_PLT_ELF_FILE_BASENAME
        export ELFCOMBINE_TOOL := ${SOFT_WORKDIR}/platform/compilation/elfCombine.pl
    endif
    
    AM_PLT_LOD_PATH := ${SOFT_WORKDIR}/platform/${strip ${AM_MODEL}}
    AM_PLT_LOD_FILE := ${wildcard ${AM_PLT_ELF_PATH}/*.lod}
    ifeq "${words ${AM_PLT_LOD_FILE}}" "0"
        ${warning WARNING: No platform lod file at path: ${AM_PLT_LOD_PATH}}
    else
        ifneq "${words ${AM_PLT_LOD_FILE}}" "1"
            ${error ERROR: More than one platform lod file at path: ${AM_PLT_LOD_PATH}}
        endif
        export AM_PLT_LOD_FILE
    endif
    
    export AM_MODEL
endif

export LODCOMBINE_TOOL := ${SOFT_WORKDIR}/platform/compilation/lodCombine.pl

########################################################################
# End of MAKELEVEL=0. Things to do only once.
########################################################################
endif

ifeq ($(MAKELEVEL),40)
$(error Recursive make reached level 40, there is probably a cycle in your module/model dependancies)
endif #MAKELEVEL 40

# Absolute path to PWD, from the Makefile
LOCAL_PATH := ${SOFT_WORKDIR}/${LOCAL_NAME}
# Corresponding path within the build tree
LOCAL_SHADOW_PATH := ${BUILD_ROOT}/${LOCAL_NAME}

# Module name.
MODULE_NAME := ${notdir ${LOCAL_NAME}}

# LOCAL_*_DIR == abstract for *_DIR, more generic (takes into account IS_ENTRY_POINT
# where we have no src/, etc...)
# For use as relative path
ifneq "${IS_ENTRY_POINT}" "yes"
    LOCAL_SRC_DIR := ${SRC_DIR}
    LOCAL_INC_DIR := ${INC_DIR}
    LOCAL_LIB_DIR := ${LIB_DIR}
else
    LOCAL_SRC_DIR := .
    LOCAL_INC_DIR := .
    LOCAL_LIB_DIR := .
endif #IS_ENTRY_POINT

## Corresponding absolute paths
# In source tree
SRC_PATH := ${LOCAL_PATH}/${SRC_DIR}
INC_PATH := ${LOCAL_PATH}/${INC_DIR}
# This one can be overwritten by packed libraries.
BINLIB_PATH ?= ${LOCAL_PATH}/${LIB_DIR}
# in build tree
DEPS_PATH := ${LOCAL_SHADOW_PATH}/${DEPS_DIR}
LIB_PATH := ${LOCAL_SHADOW_PATH}/${LIB_DIR}
OBJ_PATH := ${LOCAL_SHADOW_PATH}/${OBJ_DIR}
LOCAL_LIB_PATH := ${LOCAL_SHADOW_PATH}/${LOCAL_LIB_DIR}
#TODO REMOVE REL PATH
DEPS_REL_PATH := ${DEPS_PATH}/${CT_RELEASE}
OBJ_REL_PATH := ${OBJ_PATH}/${CT_RELEASE}

## Srecmap config files
MAP_FILE := ${SOFT_WORKDIR}/platform/compilation/${CT_ASIC}_map_cfg

## Strip symbol file
STRIP_SYMBOL_FILE := ${SOFT_WORKDIR}/platform/compilation/platform_symbols_to_strip

# ----------------------------------------------------------------------
# List all the modules that are declared as source
# ----------------------------------------------------------------------
SRC_LIBS := ${LOCAL_MODULE_DEPENDS}
SRC_LIBRARY_PATH := ${foreach MODULE_PATH, ${SRC_LIBS}, -L${BUILD_ROOT}/${MODULE_PATH}/${LIB_DIR} }
SRC_LIBRARY_FILES := ${foreach MODULE_PATH, ${SRC_LIBS}, ${BUILD_ROOT}/${MODULE_PATH}/${LIB_DIR}/lib${notdir ${MODULE_PATH}}_${CT_RELEASE}.a }

BINARY_LIBRARY_PATH := 
BINARY_LIBRARY_FILES := 

# Local built binary libs path and files: in $BUILD_ROOT
BINARY_LIBRARY_PATH += ${foreach MODULE_PATH, ${LOCAL_BUILT_BINARY_LIBS}, -L${BUILD_ROOT}/${MODULE_PATH}/${LIB_DIR} }
BINARY_LIBRARY_FILES += ${foreach MODULE_PATH, ${LOCAL_BUILT_BINARY_LIBS}, ${BUILD_ROOT}/${MODULE_PATH}/${LIB_DIR}/lib${notdir ${MODULE_PATH}}_${CT_RELEASE}.a }

# Binary libs path and files : in $SOFT_WORKDIR
BINARY_LIBRARY_PATH += ${foreach MODULE_PATH, ${BINARY_LIBS}, -L${SOFT_WORKDIR}/${MODULE_PATH}/${LIB_DIR} }
BINARY_LIBRARY_FILES += ${foreach MODULE_PATH, ${BINARY_LIBS}, ${SOFT_WORKDIR}/${MODULE_PATH}/${LIB_DIR}/lib${notdir ${MODULE_PATH}}_${CT_RELEASE}.a }

# Local libs path and files : in $SOFT_WORKDIR
LOCAL_ADD_LIBRARY_PATH := ${foreach MODULE_PATH, ${LOCAL_LIB}, -L${SOFT_WORKDIR}/${dir ${MODULE_PATH}}}
# LOCAL_LIBS is already a file list:
#LOCAL_ADD_LIBRARY_FILES := ${foreach MODULE_PATH, ${LOCAL_LIB}, ${SOFT_WORKDIR}/${MODULE_PATH}/${notdir ${MODULE_PATH}}}
LOCAL_ADD_LIBRARY_FILES := ${foreach FILE_PATH, ${LOCAL_LIB}, ${SOFT_WORKDIR}/${FILE_PATH}}

# Full libraries path used for linking -L<path_to_library>
FULL_LIBRARY_PATH := ${SRC_LIBRARY_PATH} ${BINARY_LIBRARY_PATH} ${LOCAL_ADD_LIBRARY_PATH}
# List all library files for dependencies checking full_path+"lib"+libname.a
FULL_LIBRARY_FILES := ${SRC_LIBRARY_FILES} ${BINARY_LIBRARY_FILES} ${LOCAL_ADD_LIBRARY_FILES}
# List all libraries used for linking -l(no path, just names without prefix lib)
FULL_LIBRARY_EXT := ${foreach MODULE_PATH, ${FULL_LIBRARY_FILES}, -l${patsubst lib%,%,${basename ${notdir ${MODULE_PATH}}}}}

# Used when building a toplevel with submodules only : all object files from submodules that go into the lib
ifeq "$(IS_TOP_LEVEL)" "yes"
FULL_LIBRARY_OBJECTS := ${foreach lib, ${LOCAL_MODULE_DEPENDS}, ${BUILD_ROOT}/${lib}/${OBJ_DIR}/${CT_RELEASE}/*.o} 
endif

# ----------------------------------------------------------------------
# Full List of Objects that have to be generated from src (i.e.must be compiled)
# ----------------------------------------------------------------------
FULL_SRC_OBJECTS :=	${LOCAL_OBJS} \
				    ${patsubst %.S,%.o,${S_SRC}}			\
				    ${patsubst %.c,%.o,${C_SRC}}			\
				    ${patsubst %.cpp,%.o,${C++_SRCD}}		
FULL_SRC_OBJECTS := ${foreach obj, ${FULL_SRC_OBJECTS},${OBJ_REL_PATH}/${obj}}

########################################################
## Recursive make calls 
########################################################
# When building a target, we need to build the libraries of the modules 
# declared as source first
SRC_DIRS := ${foreach MODULE_PATH, ${SRC_LIBS}, ${MODULE_PATH}}

# For all dependencies in SRC, rules to call make in dependency modules
FULL_DEPENDENCY_COMPILE := ${foreach SUBDIR, ${SRC_DIRS}, echo && ${ECHO} "MAKE              ${SUBDIR}" && ${MAKE} -C ${SOFT_WORKDIR}/${SUBDIR} all && } echo
FULL_DEPENDENCY_CLEAN := ${foreach SUBDIR, ${SRC_DIRS}, ${MAKE} -C ${SOFT_WORKDIR}/${SUBDIR} cleanstem;}
FULL_DEPENDENCY_ALLCLEAN := ${foreach SUBDIR, ${SRC_DIRS}, ${MAKE} -C ${SOFT_WORKDIR}/${SUBDIR} allcleanstem;}
FULL_DEPENDENCY_DEPCLEAN := ${foreach SUBDIR, ${SRC_DIRS}, ${MAKE} -C ${SOFT_WORKDIR}/${SUBDIR} depcleanstem;}

#################################
## Include path generation ######
#################################
# LOCAL_API_DEPENDS
# list all the include from LOCAL_API_DEPENDS
DEPENDENCY_INCLUDE_PATH := ${foreach module, ${LOCAL_API_DEPENDS}, -I${SOFT_WORKDIR}/${module}/${INC_DIR} }

# ADD all the include from LOCAL_MODULE_DEPENDS 
# (if we depend on a module, we depend on its include also)
DEPENDENCY_INCLUDE_PATH += ${foreach module, ${LOCAL_MODULE_DEPENDS}, -I${SOFT_WORKDIR}/${module}/${INC_DIR} }

# List LOCAL_ADD_INCLUDE header retrieving path
MYINCLUDEDIR := ${foreach tmpDir, ${LOCAL_ADD_INCLUDE}, -I${SOFT_WORKDIR}/${tmpDir}}

# Root include directory
ROOT_INCLUDE	:= ${SOFT_WORKDIR}/${INC_DIR}

# Final include path
# ROOT_INCLUDE at the end because DEPENDENCY_INCLUDE_PATH must be allowed to supersede it (e.g. for sxs_type.h)
INCLUDE_PATH	:= ${MYINCLUDEDIR} -I${LOCAL_INC_DIR} -I${LOCAL_SRC_DIR} ${DEPENDENCY_INCLUDE_PATH}  -I${ROOT_INCLUDE}

###################################################################################
# Linker script generation
###################################################################################
LD_SRC := ${SOFT_WORKDIR}/platform/compilation/cust.ld
LD_FILE := ${BUILD_ROOT}/cust.ld

##################################################################################
## Linker flags
##################################################################################
OFORMAT := --oformat=elf32-littlemips
SREC	:= --input-target=elf32-littlemips --output-target=srec

CODE_BASE ?= 0x00000000
EXTRA_CODE_BASE ?= 0x007D0000
EXTRA_CODE_SIZE ?= 0x00000000

LDPPFLAGS += \
        -DAM_OPENAT_ROM_BASE=${FLASH_BASE}+${AM_OPENAT_ROM_BASE} \
        -DAM_OPENAT_ROM_SIZE=${AM_OPENAT_ROM_SIZE} \
        -DAM_OPENAT_RAM_BASE=${EXT_RAM_BASE}+${AM_OPENAT_RAM_BASE} \
        -DAM_OPENAT_RAM_SIZE=${AM_OPENAT_RAM_SIZE} \
        -DDUSE_BINUTILS_2_19=1

ifeq ($(strip $(AM_CONFIG_SUPPORT)), TRUE)
    LDPPFLAGS += \
			 -DAM_CONFIG_BASE=${FLASH_BASE}+${AM_CONFIG_BASE} \
			 -DAM_CONFIG_SIZE=${AM_CONFIG_SIZE} \
			 -DAM_CONFIG_SUPPORT
endif #AM_CONFIG_SUPPORT

ifeq ($(strip $(AM_LUA_SUPPORT)), TRUE)
    LDPPFLAGS += \
    -DLUA_SCRIPT_BASE=${FLASH_BASE}+${LUA_SCRIPT_BASE} \
    -DLUA_SCRIPT_SIZE=${LUA_SCRIPT_SIZE} \
    -DAM_LUA_SUPPORT
endif

LDFLAGS += --gc-sections
LDFLAGS += ${FULL_LIBRARY_PATH} --start-group ${MYLIBFILES} ${FULL_LIBRARY_EXT} --end-group
LDFLAGS	+= -L${LIBGCC_PATH} -lgcc
LDFLAGS += --warn-common  --error-unresolved-symbols 

LDFLAG_USED_ELF_FILES := -just-symbols ${SOFT_WORKDIR}/platform/chip/rom/${CT_ASIC}/lib/mem_bridge_rom_CHIP.elf

##############################################################################
## General Targets
##############################################################################
LOCAL_LIBRARY_NOTDIR := lib${MODULE_NAME}_${CT_RELEASE}.a
LOCAL_SRCLIBRARY := ${LIB_PATH}/${LOCAL_LIBRARY_NOTDIR}
# This one can be overwritten by packed libraries.
LOCAL_BINLIBRARY ?= ${BINLIB_PATH}/${LOCAL_LIBRARY_NOTDIR}

ifneq "$(EX_VER)" ""
    LODBASE_NO_PATH := ${EX_VER}
else
    LODBASE_NO_PATH := ${PROJ_NAME}
endif

# Path for storing all the generated files for one test (elf, dis, lod...).
BINARY_PATH := ${HEX_PATH}/${LODBASE_NO_PATH}

# Change the location where everything is compiled.
BIN_PATH := ${BUILD_ROOT}/${LOCAL_NAME}

BAS := ${BIN_PATH}/${LODBASE_NO_PATH}
BIN := ${BAS}_APP.elf
MAP := ${BAS}.map
HEX := ${BAS}.srec
BAS_FINAL := ${BINARY_PATH}/${LODBASE_NO_PATH}
ifneq "${AM_PLT_ELF_FILE}" ""
BIN_FINAL := ${BAS_FINAL}.elf
else
BIN_FINAL := ${BAS_FINAL}.elf
endif
MAP_FINAL := ${BAS_FINAL}.map
HEX_FINAL := ${BAS_FINAL}.srec
LODBASE   := ${BAS_FINAL}_
LOD_FILE  := `cygpath -w $(LODBASE)flash.lod`
CFG_FILE  := ${BAS_FINAL}.cfg


ifeq "${IS_ENTRY_POINT}" "yes"
	TOP_TARGET := ${HEX}
else
	TOP_TARGET := ${LOCAL_SRCLIBRARY}
endif # IS_ENTRY_POINT

# List of directories that may need to be created
ifneq "${IS_ENTRY_POINT}" "yes"
MAKE_DIRS := ${OBJ_REL_PATH} ${DEPS_REL_PATH} ${BUILD_XCP_PATH} ${LOCAL_LIB_PATH}
else
MAKE_DIRS := ${OBJ_REL_PATH} ${DEPS_REL_PATH} ${BUILD_XCP_PATH}
endif # IS_ENTRY_POINT

#终极目标
.PHONY: default all lod bin
ifeq "${IS_ENTRY_POINT}" "yes"
default: lod
else
default: all
endif

all: $(TOP_TARGET)

lod:
	${MAKE} bin

.PHONY: targetgen
TARGET_FILE := ${BUILD_ROOT}/targetgen
targetgen: force
	@${ECHO} "#############################################"     > $(TARGET_FILE)
	@${ECHO} "# Target component definitions"                   >> $(TARGET_FILE)
	@${ECHO} "#############################################"    >> $(TARGET_FILE)
	@${ECHO} "FLSH_MODEL:=           $(FLSH_MODEL)"             >> $(TARGET_FILE)
	@${ECHO} "#############################################"    >> $(TARGET_FILE)
	@${ECHO} "# Flash Mapping"                                  >> $(TARGET_FILE)
	@${ECHO} "#############################################"    >> $(TARGET_FILE)
	@${ECHO} "FLASH_SIZE:=           $(FLASH_SIZE)"             >> $(TARGET_FILE)
	@${ECHO} "RAM_SIZE:=             $(RAM_SIZE)"               >> $(TARGET_FILE)
	@${ECHO} "RAM_PHY_SIZE:=         $(RAM_PHY_SIZE)"           >> $(TARGET_FILE)
	@${ECHO} "CALIB_BASE:=           $(CALIB_BASE)"             >> $(TARGET_FILE)
	@${ECHO} "FACT_SETTINGS_BASE:=   $(FACT_SETTINGS_BASE)"     >> $(TARGET_FILE)
	@${ECHO} "CODE_BASE:=            $(CODE_BASE)"              >> $(TARGET_FILE)
	@${ECHO} "USER_DATA_BASE:=       $(USER_DATA_BASE)"         >> $(TARGET_FILE)
	@${ECHO} "USER_DATA_SIZE:=       $(USER_DATA_SIZE)"         >> $(TARGET_FILE)
	@${ECHO} "ROMU_FLASH_LAYOUT:=    $(ROMU_FLASH_LAYOUT)"      >> $(TARGET_FILE)
ifeq ($(strip $(AM_CONFIG_SUPPORT)), TRUE)
	@${ECHO} "NV_BASE:=              $(AM_CONFIG_BASE)"         >> $(TARGET_FILE)
	@${ECHO} "NV_SIZE:=              $(AM_CONFIG_SIZE)"         >> $(TARGET_FILE)
endif #AM_CONFIG_SUPPORT
ifeq ($(strip $(AM_LUA_SUPPORT)), TRUE)
	@${ECHO} "SCRIPT_DATA_BASE:=     $(LUA_SCRIPT_BASE)"         >> $(TARGET_FILE)
	@${ECHO} "SCRIPT_DATA_SIZE:=     $(LUA_SCRIPT_SIZE)"         >> $(TARGET_FILE)
endif
	@${ECHO} "CUST_BASE:=            $(AM_OPENAT_ROM_BASE)"     >> $(TARGET_FILE)
	@${ECHO} "CUST_SIZE:=            $(AM_OPENAT_ROM_SIZE)"     >> $(TARGET_FILE)
	@${ECHO} ""                                                 >> $(TARGET_FILE)
	@${ECHO} "#############################################"    >> $(TARGET_FILE)
	@${ECHO} "# others"                                  	    >> $(TARGET_FILE)
	@${ECHO} "#############################################"    >> $(TARGET_FILE)
	@${ECHO} -e ${foreach flag, ${EXPORT_BOARD_FLAGS}, "${flag} :=\t ${${flag}}\n"} >> $(TARGET_FILE)

ifneq "${IS_ENTRY_POINT}" "yes"
bin: force
	@echo "***************************************"
	@echo "* Need to be in an entry point module *"
	@echo "* to generate lod files ! Aborted.    *"
	@echo "***************************************"
else # IS_ENTRY_POINT

CFG_Lod_File_WITH_AMC := $(shell echo $(WITH_AMC_LOD_FILE) | sed 's/.*\(SW_.*\.lod\)$$/\1/')

ifeq ($(strip $(AM_CONFIG_SUPPORT)), TRUE)
WITH_AMC_LOD_FILE=${BAS_FINAL}_WITH_AMC.lod
AM_CONFIG_FILE=$(SOFT_WORKDIR)/project/$(PROJ_NAME)/AM_Config/AM_Config.bin
CFG_Lod_File_BINE_BIN := $(shell echo $(LODBASE)flash.lod  | sed 's/.*\(SW_.*\.lod\)$$/\1/')
endif #AM_CONFIG_SUPPORT

ifneq "${AM_PLT_LOD_FILE}" ""
PLT_LOD_VERSION := $(shell echo ${AM_PLT_LOD_FILE} | sed 's/.*SW_V\([0-9]*\).*\.lod$$/B\1/')
#WITH_PLT_LOD_FILE := ${BAS_FINAL}_${PLT_LOD_VERSION}.lod
WITH_PLT_LOD_FILE := ${BAS_FINAL}.lod
CFG_Lod_File_WITH_PLT := `echo ${BAS_FINAL}_\`echo ${AM_PLT_LOD_FILE} | sed 's/.*SW_\(V[0-9]*\)\(.*\)$$/\1/'\`.lod  | sed 's/.*\(SW_.*\.lod\)$$/\1/'`
endif

AM_PROJ_CFP_FILE_DIR=$(SOFT_WORKDIR)/project/$(PROJ_NAME)/target
DES_CFP_FILE_DIR=${HEX_PATH}/${LODBASE_NO_PATH}/
AM_CFP_FILE_NAME:=`find $(AM_PROJ_CFP_FILE_DIR) -name "*.cfp"`
AM_CFP_FILE_CNT:=`find $(AM_PROJ_CFP_FILE_DIR) -name "*.cfp" | wc -l`
AM_CFP_BASE_NAME:=`basename \`find $(AM_PROJ_CFP_FILE_DIR) -name "*.cfp"\`` 

ZIP_BASENAME  := $(notdir ${BAS_FINAL}_${PLT_LOD_VERSION})

.PHONY: cfg_lod_file_with_plt cfg_lod_file_with_bin cfg_lod_file_with_amc
cfg_lod_file_with_plt: 
	$(call myfunc_cfg, $(CFG_Lod_File_WITH_PLT))

cfg_lod_file_with_bin:
	$(call myfunc_cfg, ${CFG_Lod_File_BINE_BIN})
	
cfg_lod_file_with_amc:
	$(call myfunc_cfg, ${CFG_Lod_File_WITH_AMC})	
	

ifndef   myfunc_cfg 
define   myfunc_cfg
	@${ECHO} "; 以分号;打头的行是注释，不处理。                     "   >  $(CFG_FILE)
	@${ECHO} ";																	                    "   >> $(CFG_FILE)
	@${ECHO} ";																	                    "   >> $(CFG_FILE)
	@${ECHO} "; 文件包含三个文件部分：                              "   >> $(CFG_FILE)
	@${ECHO} "; (1) Project Name,                                   "   >> $(CFG_FILE)
	@${ECHO} "; (2) Software,                                       "   >> $(CFG_FILE)
	@${ECHO} "; (3) CFG File,                                       "   >> $(CFG_FILE)
	@${ECHO} "; 有该文件在IfUsed为1，若没有该文件IfUsed为0          "   >> $(CFG_FILE)
	@${ECHO} "[Project]                                             "   >> $(CFG_FILE)
	@${ECHO} "Project Name = $(PROJ_NAME)                           "   >> $(CFG_FILE)	
	@${ECHO} "																											"   >> $(CFG_FILE)
	@${ECHO} "[Lod]                                                 "   >> $(CFG_FILE)
	@${ECHO} "IfUsed = 1                                            "   >> $(CFG_FILE)
	@${ECHO} "Lod File = $1                                         "   >> $(CFG_FILE)
	@${ECHO} "																											"   >> $(CFG_FILE)
	@${ECHO} "[Cfp]                                                 "   >> $(CFG_FILE)
	if [ $(AM_CFP_FILE_CNT) -eq 1 ]; then \
		${ECHO} "IfUsed = 1                                            "   >> $(CFG_FILE); \
		${ECHO} "Cfp File = $(AM_CFP_BASE_NAME)                        "   >> $(CFG_FILE); \
	else \
		${ECHO} "IfUsed = 0                                            "   >> $(CFG_FILE); \
	fi;
	@${ECHO} "																											"   >> $(CFG_FILE)
	@${ECHO} "																											"   >> $(CFG_FILE)
endef 
endif


ifeq ($(strip $(AM_SUBPROJ_SUPPORT)), TRUE)
ifndef   AM_SUBPROJ_CFG 
define   AM_SUBPROJ_CFG
	@${ECHO} "; 以分号;打头的行是注释，不处理。                     "   >  $(4)
	@${ECHO} ";																	                    "   >> $(4)
	@${ECHO} ";																	                    "   >> $(4)
	@${ECHO} "; 文件包含三个文件部分：                              "   >> $(4)
	@${ECHO} "; (1) Project Name,                                   "   >> $(4)
	@${ECHO} "; (2) Software,                                       "   >> $(4)
	@${ECHO} "; (3) CFG File,                                       "   >> $(4)
	@${ECHO} "; 有该文件在IfUsed为1，若没有该文件IfUsed为0          "   >> $(4)
	@${ECHO} "[Project]                                             "   >> $(4)
	@${ECHO} "Project Name = $(1)                                   "   >> $(4)	
	@${ECHO} "																											"   >> $(4)
	@${ECHO} "[Lod]                                                 "   >> $(4)
	@${ECHO} "IfUsed = 1                                            "   >> $(4)
	@${ECHO} "Lod File = $2                                         "   >> $(4)
	@${ECHO} "																											"   >> $(4)
	@${ECHO} "[Cfp]                                                 "   >> $(4)
	@${ECHO} "IfUsed = 1                                            "   >> $(4)
	@${ECHO} "Cfp File = $(3)                                       "   >> $(4)
	@${ECHO} "																											"   >> $(4)
	@${ECHO} "																											"   >> $(4)
endef 
endif

AM_SUBPROJECT_DIR = $(SOFT_WORKDIR)/project/$(PROJ_NAME)/sub_project
AM_SUBPROJECT_NAME := $(sort $(foreach dir,$(shell find ${AM_SUBPROJECT_DIR}/* -type d -print | sed 's/.*\///'),$(strip $(dir))))

AM_SUBPROJ_FILE_BIN = bin
AM_SUBPROJ_FILE_CFP = cfp
AM_SUBPROJ_FILE_DIR = $(SOFT_WORKDIR)/project/$(PROJ_NAME)/sub_project/$(1)
AM_SUBPROJ_FILE_NAME = $(shell find $(call AM_SUBPROJ_FILE_DIR,$(1)) -name "*.$(2)")
AM_SUBPROJ_FILE_CNT = $(shell find $(call AM_SUBPROJ_FILE_DIR,$(1)) -name "*.$(2)" | wc -l)

AM_SUBPROJECT_HEX_DIRNAME = $(BAS_FINAL)_$(1)_$(PLT_LOD_VERSION)

AM_SUBPROJ_CFG_FILENAME = $(call AM_SUBPROJECT_HEX_DIRNAME,$(1))/$(1).cfg

AM_SUBPORJECT_MAKE = $(foreach subtarget,$(AM_SUBPROJECT_NAME),${MAKE} $(subtarget))


AM_SUBPORJECT_MAKE = \
	for subtarget

AM_SUBPROJ_FILE_CP = \
	if [ $(3) -gt 1 ]; then  \
	${ECHO} "COPY $(4) FILE        There are $(3) find $(4) files."; \
		exit 1; \
	else \
		if [ $(3) -eq 1 ]; then \
			cp -f $(2) $(call AM_SUBPROJECT_HEX_DIRNAME,$(1))/; \
    else \
			if [ $(3) -eq 0 ]; then \
				${ECHO} "COPY $(4) FILE        Cannot find $(4) file"; \
				exit 1; \
			fi;\
		fi;\
	fi\


ifeq ($(strip $(AM_CONFIG_SUPPORT)), TRUE)

AM_SUBPROJECT_HEXAMC_NAME = $(BAS_FINAL)_$(1)_$(PLT_LOD_VERSION)/$(LODBASE_NO_PATH)_$(1)_WITH_AMC.lod

AM_SUBPROJ_FILE_LOD_WITH_AMC = \
	if [ -f $(2) ]; then                                                                 \
		if [ -f $(3) ]; then                                                       \
			$(LODCOMBINE_TOOL) amc -l $(2) -i $(3) -o $(4); \
			if [ $$? -gt 0 ]; then \
				${ECHO} "LODCOMBINE        Combine failed";   \
				exit 1; \
			fi;\
			${ECHO} "LODCOMBINE        Combine sucessful";                                     \
		else                                                                                    \
			${ECHO} "LODCOMBINE        Cannot find AM Conifg file:$(3)";   \
		fi;                                                                                     \
	else                                                                                        \
		${ECHO} "LODCOMBINE        Cannot find lod file:$(2)";		            \
	fi;

endif #AM_CONFIG_SUPPORT


ifneq "${AM_PLT_LOD_FILE}" ""

AM_SUBPROJECT_HEX_PLT_NAME = $(call AM_SUBPROJECT_HEX_DIRNAME,$(1))/$(basename $(notdir $(call AM_SUBPROJECT_HEX_DIRNAME,$(1)))).lod

AM_SUBPROJ_FILE_LOD_PLT = \
	if [ -f $(3) ]; then                                                                 \
		if [ -f $(2) ]; then                                                       \
			$(LODCOMBINE_TOOL) openat -l $(2) -i $(3) -o $(4); \
			if [ $$? -gt 0 ]; then \
				${ECHO} "LODCOMBINE        Combine failed";   \
				exit 1; \
			fi;\
			${ECHO} "LODCOMBINE        Combine sucessful";                                     \
		else                                                                                    \
			${ECHO} "LODCOMBINE        Cannot find Platform lod file:$(2)";   \
		fi;                                                                                     \
	else                                                                                        \
		${ECHO} "LODCOMBINE        Cannot find lod file:$(3)";		            \
	fi;
	
endif

endif #AM_SUBPROJ_SUPPORT


AM_SUBPROJ_ZIP = \
	cd $(2)/$(1) && zip $(1).zip ./* -x $(3);\
	mv $(2)/$(1)/$(1).zip $(2);
	

.PHONY: $(AM_SUBPROJECT_NAME)
$(AM_SUBPROJECT_NAME):
	mkdir -p $(BAS_FINAL)_$@_$(PLT_LOD_VERSION)

	find $(call AM_SUBPROJECT_HEX_DIRNAME,$@) -name "*.cfp" -exec rm {} \; 
	find $(call AM_SUBPROJECT_HEX_DIRNAME,$@) -name "*.bin" -exec rm {} \;
	
	@${ECHO}
	@${ECHO} "CP FILE           SUB Project $@ Copy File..."
	$(call AM_SUBPROJ_FILE_CP,$@,$(call AM_SUBPROJ_FILE_NAME,$@,$(AM_SUBPROJ_FILE_CFP)),$(call AM_SUBPROJ_FILE_CNT,$@,$(AM_SUBPROJ_FILE_CFP)),$(AM_SUBPROJ_FILE_CFP))
	$(call AM_SUBPROJ_FILE_CP,$@,$(call AM_SUBPROJ_FILE_NAME,$@,$(AM_SUBPROJ_FILE_BIN)),$(call AM_SUBPROJ_FILE_CNT,$@,$(AM_SUBPROJ_FILE_BIN)),$(AM_SUBPROJ_FILE_BIN))
	@${ECHO} "CP FILE           Copy File Sucessful"
	
	@${ECHO}
	@${ECHO} "LODCOMBINE        SUB Project $@ Combine with AMC bin"
	$(call AM_SUBPROJ_FILE_LOD_WITH_AMC,$@,$(LOD_FILE),$(call AM_SUBPROJ_FILE_NAME,$@,$(AM_SUBPROJ_FILE_BIN)),$(call AM_SUBPROJECT_HEXAMC_NAME,$@))
	
	@${ECHO}
	@${ECHO} "LODCOMBINE        SUB Project $@ Combine with Platform lod"
	$(call AM_SUBPROJ_FILE_LOD_PLT,$@,$(AM_PLT_LOD_FILE),$(call AM_SUBPROJECT_HEXAMC_NAME,$@),$(call AM_SUBPROJECT_HEX_PLT_NAME,$@))

	@${ECHO}
	@${ECHO} "Creat Cfg         SUB Project $@ Creat Cfg File"
	$(call AM_SUBPROJ_CFG,$@,$(notdir $(call AM_SUBPROJECT_HEX_PLT_NAME,$@)),$(notdir $(call AM_SUBPROJ_FILE_NAME,$@,$(AM_SUBPROJ_FILE_CFP))),$(call AM_SUBPROJ_CFG_FILENAME,$@))
	@${ECHO} "Creat Cfg         Creat Cfg Sucessful"
	
	@${ECHO}
	@${ECHO} "Creat Zip         SUB Project $@ Creat ZIP File"
	$(call AM_SUBPROJ_ZIP,$(notdir $(call AM_SUBPROJECT_HEX_DIRNAME,$@)),$(BINARY_PATH),$(notdir $(call AM_SUBPROJECT_HEXAMC_NAME,$@)))
	@${ECHO} "Creat Zip         Creat Zip Sucessful"
	@${ECHO}
	@${ECHO}

AM_MAP_ZIP: force
	mkdir -p $(BINARY_PATH)/$(LODBASE_NO_PATH)_map
	cp -f $(BIN) $(BINARY_PATH)/$(LODBASE_NO_PATH)_map/
	cp -f $(AM_PLT_LOD_FILE) $(BINARY_PATH)/$(LODBASE_NO_PATH)_map/
	cp -f $(AM_PLT_ELF_FILE) $(BINARY_PATH)/$(LODBASE_NO_PATH)_map/
	cp -f $(BIN_FINAL) $(BINARY_PATH)/$(LODBASE_NO_PATH)_map/
	cp -f $(basename $(BIN_FINAL)).map $(BINARY_PATH)/$(LODBASE_NO_PATH)_map/
	cp -f $(LOD_FILE) $(BINARY_PATH)/$(LODBASE_NO_PATH)_map/
	
	@${ECHO} "Creat map Zip..."
	cd $(BINARY_PATH) && zip $(LODBASE_NO_PATH)_map.zip -r $(LODBASE_NO_PATH)_map;
	@${ECHO} "Creat map Zip     Creat map Zip Sucessful"
	@${ECHO}

bin: all
ifeq ($(strip $(AM_SUBPROJ_SUPPORT)), TRUE)
	@${ECHO} "SREC              ${LODBASE_NO_PATH}.srec for flash/romulator"
	${MAKE} targetgen
	srecmap -c ${MAP_FILE} -m ${FLSH_MODEL} -b ${TARGET_FILE} ${HEX} ${LODBASE} ${STDOUT_NULL}
	
	for subtarget in $(AM_SUBPROJECT_NAME); \
	do \
	${MAKE} $${subtarget}; \
	done

	${MAKE} AM_MAP_ZIP
		
else
	find $(DES_CFP_FILE_DIR) -name "*.cfp" -exec rm {} \;
	
	@${ECHO} "CP  		  AUDIO CFP FILE......"
	if [ $(AM_CFP_FILE_CNT) -gt 1 ]; then  \
		${ECHO} "AUDIO CFG         There are $(AM_CFP_FILE_CNT) find audio cfp files."; \
		exit 1; \
	else \
		if [ $(AM_CFP_FILE_CNT) -eq 1 ]; then \
			cp -f ${AM_CFP_FILE_NAME} ${DES_CFP_FILE_DIR};\
		else\
			if [ $(AM_CFP_FILE_CNT) -eq 0 ]; then \
				${ECHO} "AUDIO CFG         Cannot find audio cfp file"; \
#				exit 1; \
			fi;\
		fi;\
	fi;	
	
	@${ECHO} "SREC              ${LODBASE_NO_PATH}.srec for flash/romulator"
	${MAKE} targetgen
	srecmap -c ${MAP_FILE} -m ${FLSH_MODEL} -b ${TARGET_FILE} ${HEX} ${LODBASE} ${STDOUT_NULL}
ifeq ($(strip $(AM_CONFIG_SUPPORT)), TRUE)
	@${ECHO}
	@${ECHO} "LODCOMBINE        Combine with AMC bin"
	if [ -f $(LOD_FILE) ]; then                                                                 \
		if [ -f $(AM_CONFIG_FILE) ]; then                                                       \
			$(LODCOMBINE_TOOL) amc -l $(LOD_FILE) -i $(AM_CONFIG_FILE) -o $(WITH_AMC_LOD_FILE); \
			if [ $$? -gt 0 ]; then \
				${ECHO} "LODCOMBINE        Combine failed";   \
				exit 1; \
			fi;\
			${ECHO} "LODCOMBINE        Combine sucessful";                                     \
			rm -f $(LOD_FILE);                                                                  \
			mv $(WITH_AMC_LOD_FILE) $(LOD_FILE);                                                 \
		else                                                                                    \
			${ECHO} "LODCOMBINE        Cannot find AM Conifg file:$(AM_CONFIG_FILE)";   \
		fi;                                                                                     \
	else                                                                                        \
		${ECHO} "LODCOMBINE        Cannot find lod file:$(LOD_FILE)";		            \
	fi;
endif #AM_CONFIG_SUPPORT
ifneq "${AM_PLT_LOD_FILE}" ""
	@${ECHO}
	@${ECHO} "LODCOMBINE        Combine with Platform lod"
	if [ -f $(LOD_FILE) ]; then                                                                 \
		if [ -f $(AM_PLT_LOD_FILE) ]; then                                                       \
			$(LODCOMBINE_TOOL) openat -l $(AM_PLT_LOD_FILE) -i $(LOD_FILE) -o $(WITH_PLT_LOD_FILE); \
			if [ $$? -gt 0 ]; then \
				${ECHO} "LODCOMBINE        Combine failed";   \
				exit 1; \
			fi;\
			${ECHO} "LODCOMBINE        Combine sucessful";                                     \
			${ECHO} "AirLodModify        $(shell ${CYGPATH} $(WITH_PLT_LOD_FILE)) $(shell ${CYGPATH} ${BAS_FINAL}_${PLT_LOD_VERSION}_LAST.lod )";                       \
			${SOFT_WORKDIR}/platform/AirLodModify.exe $(shell ${CYGPATH} $(WITH_PLT_LOD_FILE)); \
		else                                                                                    \
			${ECHO} "LODCOMBINE        Cannot find Platform lod file:$(AM_PLT_LOD_FILE)";   \
		fi;                                                                                     \
	else                                                                                        \
		${ECHO} "LODCOMBINE        Cannot find lod file:$(LOD_FILE)";		            \
	fi;
endif

ifneq "${AM_PLT_LOD_FILE}" ""
	if [ -f $(WITH_PLT_LOD_FILE) ]; then                                           \
			${MAKE} cfg_lod_file_with_plt;                                           \
	fi;
else
	if [ -f $(LODBASE)flash.lod ]; then	                                       \
			${MAKE} cfg_lod_file_with_bin;                                           \
	else                                                                         \
			${MAKE} cfg_lod_file_with_amc;                                           \
	fi;    
endif
			
endif #AM_SUBPROJ_SUPPORT

	@${ECHO}
	
ifneq "${AM_PLT_LOD_FILE}" ""
	${MAKE} AM_PROJECT_ZIP
endif

	@${ECHO}

AM_PROJECT_ZIP: force
	mkdir -p ${BAS_FINAL}_${PLT_LOD_VERSION}
	#cp -f ${BAS_FINAL}_${PLT_LOD_VERSION}.lod ${BAS_FINAL}_${PLT_LOD_VERSION}/
	cp -f ${BAS_FINAL}.lod ${BAS_FINAL}_${PLT_LOD_VERSION}/
ifeq ($(strip $(AM_CONFIG_SUPPORT)), TRUE)
	cp -f $(AM_CONFIG_FILE) ${BAS_FINAL}_${PLT_LOD_VERSION}/
endif
	if [ $(AM_CFP_FILE_CNT) -eq 1 ]; then \
		cp -f $(AM_CFP_FILE_NAME) ${BAS_FINAL}_${PLT_LOD_VERSION}/; \
	fi;
	cp -f $(CFG_FILE) ${BAS_FINAL}_${PLT_LOD_VERSION}/

	@${ECHO} "Creat hex Zip..."
	cd $(BINARY_PATH) && zip ${ZIP_BASENAME}.zip -r ${ZIP_BASENAME};
	@${ECHO} "Creat hex Zip     Creat hex Zip Sucessful"
	@${ECHO}
	rm -rf ${BAS_FINAL}_${PLT_LOD_VERSION}


	mkdir -p ${BAS_FINAL}_${PLT_LOD_VERSION}_map
	cp -f $(AM_PLT_LOD_FILE) ${BAS_FINAL}_${PLT_LOD_VERSION}_map/
	cp -f $(AM_PLT_ELF_FILE) ${BAS_FINAL}_${PLT_LOD_VERSION}_map/
	cp -f $(BIN_FINAL) ${BAS_FINAL}_${PLT_LOD_VERSION}_map/
	cp -f ${BAS_FINAL}.map ${BAS_FINAL}_${PLT_LOD_VERSION}_map/
	cp -f $(LOD_FILE) ${BAS_FINAL}_${PLT_LOD_VERSION}_map/
	#删除flash.lod文件，保留合并后的lod文件
	rm -f $(LOD_FILE)

	@${ECHO} "Creat map Zip..."
	cd $(BINARY_PATH) && zip $(ZIP_BASENAME)_map.zip -r ${ZIP_BASENAME}_map;
	@${ECHO} "Creat map Zip     Creat map Zip Sucessful"
	@${ECHO}
	rm -rf ${BAS_FINAL}_${PLT_LOD_VERSION}_map

endif

${HEX}: force
	${MAKE} ${BIN}
	$(OBJCOPY) ${OBJCPY_OPTS} ${SREC} ${BIN} ${HEX}

${BIN}: dependencies ${FULL_SRC_OBJECTS} ${FULL_LIBRARY_FILES} | ${BIN_PATH} ${BINARY_PATH}
	@${ECHO}
	#
	@${ECHO} "LDGEN             ${notdir ${LD_FILE}}"
	test -f ${LD_FILE} && chmod +w ${LD_FILE} || echo ""
	${LDPP} ${LDPPFLAGS} ${LD_SRC} > ${LD_FILE}
	#
	@${ECHO} "LD                ${notdir ${BIN}}"
	${LD} -nostdlib -o ${BIN} ${OFORMAT} ${FULL_SRC_OBJECTS} ${LD_OPTIONAL_OBJECTS} \
		${LDFLAG_USED_ELF_FILES}	\
		--script ${LD_FILE} \
		$(LDFLAGS) \
		-Map ${MAP}
	#

ifneq "${IS_DLL_ENTRY}" "yes"
ifneq "${AM_PLT_ELF_FILE}" ""
	@${ECHO} "ElfCombine        Elf binary & map file"

	#将平台和cust elf拷贝到hex目录下操作，原来的elf都在原始目录保持原样
	${CP} -f ${BIN} ${BINARY_PATH}
	${CP} -f ${AM_PLT_ELF_FILE} ${BINARY_PATH}
	
	#将客户的elf中的symbol去掉
	@${ECHO}
	${ECHO} "GEN               stripped (rm syms) elf file ${notdir ${BIN}}"
	#${OBJCOPY} --strip-symbols=${STRIP_SYMBOL_FILE} ${BAS_FINAL}.elf ${BAS_FINAL}.elf
	${OBJCOPY} --strip-symbols=${STRIP_SYMBOL_FILE} ${BINARY_PATH}/${notdir ${BIN}} ${BINARY_PATH}/${notdir ${BIN}}
	
	#合并elf
	${ELFCOMBINE_TOOL} -e1 ${BINARY_PATH}/${notdir ${BIN}} -e2 ${BINARY_PATH}/${AM_PLT_ELF_FILE_BASENAME} -o ${BIN_FINAL}

	#删除掉拷贝过来的elf
	-rm -f ${BINARY_PATH}/${notdir ${BIN}}
	-rm -f ${BINARY_PATH}/${AM_PLT_ELF_FILE_BASENAME}
	@${ECHO}	
	
else
	@${ECHO} "CP                Elf binary & map file"
	${CP} ${BIN} ${BIN_FINAL}
	${CP} ${MAP} ${MAP_FINAL}
endif
endif

$(LOCAL_SRCLIBRARY): ${FULL_SRC_OBJECTS} | makedirs ccflagoutput
	@${ECHO} "AR                ${notdir ${LOCAL_SRCLIBRARY}}"
	$(AR) cru ${LOCAL_SRCLIBRARY} ${FULL_SRC_OBJECTS} ${STDERR_NULL} || ${ECHO} "	Error in AR"

ccflagoutput: force
	if [ ! -d ${OBJ_REL_PATH} ]; then mkdir -p ${OBJ_REL_PATH}; fi;
	$(ECHO) $(C_SPECIFIC_CFLAGS) $(CFLAGS) $(CT_MIPS16_CFLAGS) $(MYCFLAGS) $(CPPFLAGS) | sed 's/ /\r\n/g' > $(OBJ_REL_PATH)/cc.via
	$(ECHO) $(ASCPPFLAGS) | sed 's/ /\r\n/g' > $(OBJ_REL_PATH)/asm.via

.PHONY: force
force: ;

# Avoid searching implicit rules for makefiles, as we do not re-generate them
Makefile: ;
%.mk: ;
%.def: ;
%.srcs: ;
%.d: ;

# Avoid searching implicit rules for source files, as we do not generate
# them automatically
%.cpp: ;
%.c: ;
%.S: ;

# Avoid searching implicit rules for header files. Some of them will be generated
# during xmd2h, xcp2h, or updateversion process. However, they are not listed
# as targets in a rule in xmd2h and updateversion; and in xcp2h they are listed
# as targets in an ordinary rule (not an implicit/pattern rule), e.g., ${XCP_OUTPUT_FILE}.
# Since an ordinary rule with commands will take precedence of any implicit/pattern rule,
# we can safely stop searching implicit rules for all these files.
%.h: ;

# Avoid searching implicit rules for XCP files. They are listed as targets in an
# ordinary rule during xcp2h process, e.g., ${XCP_BUILD_FILE} and ${XCP_FINAL}.
# Since an ordinary rule with commands will take precedence of any implicit/pattern rule,
# we can safely stop searching implicit rules for all these files.
%.xcp: ;

###################### Directories #######################################
${LOCAL_LIB_PATH}:
	mkdir -p ${LOCAL_LIB_PATH}

ifneq "${BINLIB_PATH}" "${LOCAL_LIB_PATH}"
${BINLIB_PATH}:
	mkdir -p ${BINLIB_PATH}
endif
    
${OBJ_REL_PATH}:
	mkdir -p ${OBJ_REL_PATH}

${BINARY_PATH}:
	mkdir -p ${BINARY_PATH}

${DEPS_REL_PATH}:
	mkdir -p ${DEPS_REL_PATH}

${BIN_PATH}:
	mkdir -p ${BIN_PATH}

${BUILD_XCP_PATH}:
	mkdir -p ${BUILD_XCP_PATH}


##################################################################################
## Compilation rules
##################################################################################

ifeq "${WITH_FULL_PATH}" "1"
REALPATH=$(abspath $<)
else
REALPATH=$<
endif # WITH_FULL_PATH := 1

##################################################################################
## Compilation flags
##################################################################################
#------------------- c file flags --------------------------------------
C_SPECIFIC_CFLAGS += -std=gnu99 \
                     -Woverride-init \
                     -Wno-pointer-sign

CFLAGS += -Wshadow \
          -Os -g -fno-inline-small-functions -fno-inline-functions -fno-align-functions -fno-align-jumps -fno-align-loops -fno-align-labels \
          -msoft-float \
          -Wundef -Wunused-function \
          -Wuninitialized \
          -minterlink-mips16 -fno-strict-aliasing \
          -ffunction-sections -fdata-sections \
          -fno-builtin-iswspace \
          -ffixed-t3 -ffixed-t4 -ffixed-t5 -ffixed-t6 -ffixed-t7 -ffixed-s2 -ffixed-s3 -ffixed-s4 -ffixed-s5 -ffixed-s6 -ffixed-s7 -ffixed-fp \
          -G0 -Wall -march=xcpu -mtune=xcpu -Wa,-march=xcpu,-mtune=xcpu -EL -mexplicit-relocs -fweb -frename-registers -mmemcpy -mmips-tfile -nostartfiles -nostdlib -nostdinc -nodefaultlibs -c -pipe \
          -fwide-exec-charset=UTF-16LE -fshort-wchar

CT_MIPS16_CFLAGS += -mips16

#------------------- asm file flags --------------------------------------
# Assembly compilation flags
ASFLAGS += -march=xcpu -mtune=xcpu -EL 

#------------------- cpp file flags --------------------------------------
C++_SPECIFIC_CFLAGS += -Wno-write-strings

#------------------- pp file flags --------------------------------------
    
PLT_LOD_FILE := ${notdir ${wildcard ${SOFT_WORKDIR}/platform/${strip ${AM_MODEL}}/*.lod}}
PLA_LOD_VER := $(shell echo ${PLT_LOD_FILE} | sed 's/.*SW_V\([0-9]*\).*\.lod$$/B\1/')

ASCPPFLAGS += -DCT_ASM
MYCPPFLAGS += -D__NEW_GCC__ \
              -DUSE_GCC_4=1 -DUSE_BINUTILS_2_19=1 \
              -D__REDUCED_REGS__ \
			  -DLUA_SCRIPT_BASE=$(LUA_SCRIPT_BASE) \
			  -DLUA_SCRIPT_SIZE=$(LUA_SCRIPT_SIZE) \
			  -DAM_OPENAT_ROM_BASE=$(AM_OPENAT_ROM_BASE) \
			  -DAM_OPENAT_ROM_SIZE=$(AM_OPENAT_ROM_SIZE) \
			  -DPLT_LOD_VERSION=\"${PLA_LOD_VER}\"
# User flags
ALL_EXPORT_FLAG := $(sort ${ALL_EXPORT_FLAG} ${LOCAL_EXPORT_FLAG})
MYCPPFLAGS := ${MYCPPFLAGS} ${foreach tmpFlag, ${ALL_EXPORT_FLAG}, -D${tmpFlag}}

CPPFLAGS	= ${INCLUDE_PATH} -DEL ${MYCPPFLAGS}

############################ Implicit rules ########################################
# We generate one dependency file on the fly for each source file, 
# either when preprocessing for asm files, or when compiling for C files.
# Those depfiles are also board depend (to deal with conditional includes)
# Empty rules are generated for all header files, to avoid issues in case one header is deleted (-MP)
${OBJ_REL_PATH}/%.o: ${LOCAL_SRC_DIR}/%.S
	@${ECHO} "CPP               $*.S"
	$(CPP) $(CPPFLAGS) $(ASCPPFLAGS)  -MT ${OBJ_REL_PATH}/$*.o -MD -MP -MF ${DEPS_REL_PATH}/$*.d -o ${OBJ_REL_PATH}/$*.asm $(REALPATH)
	@${ECHO} "AS                $*.asm"
	$(AS) $(ASFLAGS) -o ${OBJ_REL_PATH}/$*.o ${OBJ_REL_PATH}/$*.asm

${OBJ_REL_PATH}/%.o: ${LOCAL_SRC_DIR}/%.c
	@${ECHO} "CC                $*.c"
	$(CC) -MT ${OBJ_REL_PATH}/$*.o -MD -MP -MF ${DEPS_REL_PATH}/$*.d $(C_SPECIFIC_CFLAGS) $(CFLAGS) $(CT_MIPS16_CFLAGS) $(MYCFLAGS) $(CPPFLAGS)  -o ${OBJ_REL_PATH}/$*.o $(REALPATH)

${OBJ_REL_PATH}/%.o: ${LOCAL_SRC_DIR}/%.cpp
	@${ECHO} "C++               $*.cpp"
	$(C++) -MT ${OBJ_REL_PATH}/$*.o -MD -MP -MF ${DEPS_REL_PATH}/$*.d $(C++_SPECIFIC_CFLAGS) $(CFLAGS) $(CT_MIPS16_CFLAGS) $(MYCFLAGS) $(CPPFLAGS)  -o ${OBJ_REL_PATH}/$*.o $(REALPATH) $(EXTERN_CPPFLAGS)

# The libraries are always generated before. This rule respond allways true.
%.a:
	echo -n ""

######################### library stuff #########################################
.PHONY: makedirs headergen dependencies ccflagoutput

makedirs: ${MAKE_DIRS}
dependencies: force
# The '+' token works like ${MAKE} directly in the line content.
	+@${FULL_DEPENDENCY_COMPILE}

ifneq "${strip ${FULL_SRC_OBJECTS}}" ""
# Prerequisites are order-only as we do not want to re-build the
# source objects in every make run (depending on phony targets)
${FULL_SRC_OBJECTS}: | makedirs headergen
endif # FULL_SRC_OBJECTS

clean:
#	@${ECHO} "BUILD_ROOT=${BUILD_ROOT}"
#	@${ECHO} "BINARY_PATH=${BINARY_PATH}"
	-rm -rf ${BUILD_ROOT}
	-rm -rf ${BINARY_PATH}
	@${ECHO} 
	@${ECHO} "CLEAN             Complete"
	@${ECHO} 
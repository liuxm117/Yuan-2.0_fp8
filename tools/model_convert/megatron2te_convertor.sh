#!/bin/bash

set -e
START_TIME=$SECONDS

MEGATRON_PATH=$1
SOURCE_CKPT_PATH=$2
TARGET_CKPT_PATH=$3
TP=$4
PP=$5
MN=$6 #llama-7b, llama-13b, llama-30b, llama-65b, llama2-7b, llama2-13b, llama2-70b
EXTRA_VOCAB_SIZE=$7

#if [ $hf2te = true ]; then
#    do_options="
#                --convert_checkpoint_from_transformers_to_te
#    "
#elif [ $hf2te = false ]; then
#    do_options=""
#fi

export PYTHONPATH=${MEGATRON_PATH}:$PYTHONPATH

python tools/model_convert/megatron2te.py \
--load_path ${SOURCE_CKPT_PATH} \
--save_path ${TARGET_CKPT_PATH} \
--target_params_dtype bf16 \
--megatron-path ${MEGATRON_PATH} \
--target_tensor_model_parallel_size ${TP} \
--target_pipeline_model_parallel_size ${PP} \
--model_name ${MN} \
--extra_num_vocabs ${EXTRA_VOCAB_SIZE}

ELAPSED_TIME=$(($SECONDS - $START_TIME))
echo "$(($ELAPSED_TIME/60)) min $(($ELAPSED_TIME%60)) sec"
